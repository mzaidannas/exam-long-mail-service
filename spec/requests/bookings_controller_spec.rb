require "rails_helper"

describe Api::V1::BookingsController, type: :request do
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({"Accept" => "application/json", "Content-Type" => "application/json"}, user) }
  let!(:trains) { create_list(:train, 3, operator: user) }
  let!(:parcels) { create_list(:parcel, 10, train: trains.sample) }
  let(:train_attributes) { %i[id name cost weight volume lines cost_per_kg operator_name] }

  before :each do
    LINES.each { |line| Line.find_or_create_by(name: line, booked: false) }
  end

  describe "Booking" do
    let(:user) { create(:user, :postmaster) }
    before :all do
      Rails.cache.clear
    end

    context "when user is postmaster" do
      it "#index" do
        get "/bookings#index", headers: headers
        expect(response).to have_http_status(:ok)
        expect(Oj.load(response.body, symbolize_names: true).first.keys).to contain_exactly(*train_attributes)
      end

      it "#create", :sidekiq_inline do
        allow(TrainReachedJob).to receive(:perform_at).and_return(true)
        post "/bookings#create", params: {train_id: trains.first.id}.to_json, headers: headers
        expect(response).to have_http_status(:created)
        expect(Booking.count).to_not be_zero
        expect(trains.first.reload.status).to eq("booked")
      end
    end
  end
end
