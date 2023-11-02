require "rails_helper"

describe Api::V1::TrainsController, type: :request do
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({"Accept" => "application/json", "Content-Type" => "application/json"}, user) }
  let(:params) { attributes_for(:train, operator: user) }
  let(:train) { create(:train, operator: user) }

  describe "operator" do
    let(:user) { create(:user) }

    context "when user is operator of the train" do
      it "#index" do
        create_list(:train, 3, operator: user)
        get "/trains#index", headers: headers
        expect(response).to have_http_status(:ok)
        expect(Oj.load(response.body, symbolize_names: true)[:data]).to be_present
      end

      it "#show" do
        get "/trains/#{train.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(Oj.load(response.body, symbolize_names: true)[:data][:id]).to be_present
      end

      it "#create" do
        expect(Train.count).to be_zero
        post "/trains#create", params: params.to_json, headers: headers
        expect(response).to have_http_status(:created)
        expect(Oj.load(response.body, symbolize_names: true)[:data][:id]).to be_present
        expect(Train.count).to_not be_zero
      end

      it "#withdraw" do
        get "/trains/#{train.id}/withdraw", headers: headers
        expect(response).to have_http_status(:accepted)
        expect(Oj.load(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq("withdrawn")
        expect(train.reload.status).to eq("withdrawn")
      end

      context "when train has already booked" do
        let(:train) { create(:train, :booked, operator: user) }
        it "#booked" do
          get "/trains/#{train.id}/withdraw", headers: headers
          expect(response).to have_http_status(:not_acceptable)
          expect(Oj.load(response.body, symbolize_names: true)[:message]).to eq("Train is booked")
          expect(Oj.load(response.body, symbolize_names: true)[:detail]).to eq("You can't withdraw a train that has already been booked")
          expect(train.reload.status).to eq("booked")
        end
      end

      context "when train is already withdrawn" do
        let(:train) { create(:train, :withdrawn, operator: user) }
        it "#withdraw" do
          get "/trains/#{train.id}/withdraw", headers: headers
          expect(response).to have_http_status(:not_acceptable)
          expect(Oj.load(response.body, symbolize_names: true)[:message]).to eq("Train is withdrawn")
          expect(Oj.load(response.body, symbolize_names: true)[:detail]).to eq("You can't withdraw a train that has already been withdrawn")
          expect(train.reload.status).to eq("withdrawn")
        end
      end
    end

    context "when user is not the operator of train" do
      let(:train2) { create(:train) }
      it "#show" do
        get "/trains/#{train2.id}", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end

      it "#withdraw" do
        get "/trains/#{train2.id}/withdraw", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "owner" do
    let(:user) { create(:user, :owner) }
    it "#index" do
      create_list(:train, 3)
      get "/trains#index", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#show" do
      get "/trains/#{train.id}", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#create" do
      post "/trains#create", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#withdraw" do
      get "/trains/#{train.id}/withdraw", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "postmaster" do
    let(:user) { create(:user, :postmaster) }
    it "#index" do
      create_list(:train, 3)
      get "/trains#index", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "#show" do
      get "/trains/#{train.id}", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#create" do
      post "/trains#create", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#withdraw" do
      get "/trains/#{train.id}/withdraw", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
