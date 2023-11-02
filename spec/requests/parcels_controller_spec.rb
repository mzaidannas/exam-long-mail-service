require "rails_helper"

describe Api::V1::ParcelsController, type: :request do
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({"Accept" => "application/json", "Content-Type" => "application/json"}, user) }
  let(:params) { attributes_for(:parcel, owner: user) }
  let(:parcel) { create(:parcel, owner: user) }

  describe "owner" do
    let(:user) { create(:user, :owner) }

    context "when user is owner of the parcel" do
      it "#index" do
        create_list(:parcel, 3, owner: user)
        get "/parcels#index", headers: headers
        expect(response).to have_http_status(:ok)
        expect(Oj.load(response.body, symbolize_names: true)[:data]).to be_present
      end

      it "#show" do
        get "/parcels/#{parcel.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(Oj.load(response.body, symbolize_names: true)[:data][:id]).to be_present
      end

      it "#create" do
        expect(Parcel.count).to be_zero
        post "/parcels#create", params: params.to_json, headers: headers
        expect(response).to have_http_status(:created)
        expect(Oj.load(response.body, symbolize_names: true)[:data][:id]).to be_present
        expect(Parcel.count).to_not be_zero
      end

      context "when parcel is not delivered" do
        it "#retrieve" do
          get "/parcels/#{parcel.id}/retrieve", headers: headers
          expect(response).to have_http_status(:not_acceptable)
          expect(Oj.load(response.body, symbolize_names: true)[:message]).to eq("Parcel is not delivered")
          expect(Oj.load(response.body, symbolize_names: true)[:detail]).to eq("You can't retrieve a parcel that has not been delivered yet")
          expect(parcel.reload.status).to eq("pending")
        end
      end

      context "when parcel is delivered" do
        let(:parcel) { create(:parcel, :delivered, owner: user) }

        it "#retrieve" do
          get "/parcels/#{parcel.id}/retrieve", headers: headers
          expect(response).to have_http_status(:accepted)
          expect(Oj.load(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq("retrieved")
          expect(parcel.reload.status).to eq("retrieved")
        end
      end
    end

    context "when user is not the owner of parcel" do
      let(:parcel2) { create(:parcel) }
      it "#show" do
        get "/parcels/#{parcel2.id}", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end

      it "#retrieve" do
        get "/parcels/#{parcel2.id}/retrieve", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "operator" do
    let(:user) { create(:user) }
    it "#index" do
      create_list(:parcel, 3)
      get "/parcels#index", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#show" do
      get "/parcels/#{parcel.id}", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#create" do
      post "/parcels#create", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#retrieve" do
      get "/parcels/#{parcel.id}/retrieve", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "postmaster" do
    let(:user) { create(:user, :postmaster) }
    it "#index" do
      create_list(:parcel, 3)
      get "/parcels#index", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#show" do
      get "/parcels/#{parcel.id}", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#create" do
      post "/parcels#create", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end

    it "#retrieve" do
      get "/parcels/#{parcel.id}/retrieve", headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
