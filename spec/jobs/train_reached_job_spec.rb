require "rails_helper"

describe TrainReachedJob, type: :job do
  let(:user) { create(:user, :postmaster) }
  let(:train) { create(:train) }
  let(:parcels) { create_list(:parcel, 10, train: train) }
  let(:booking) { create(:booking, train: train, postmaster: user, parcels: parcels) }
  let(:scheduled_job) { described_class.perform_async(booking.id) }
  describe "Train Reached", :sidekiq_inline do
    before :each do
      LINES.each { |line| Line.create(name: line, booked: false) }
    end

    it "Should free the line" do
      scheduled_job
      expect(Line.find_by(name: booking.line).booked).to be_falsey
    end

    it "Should update the train status" do
      scheduled_job
      expect(train.reload.status).to eq("reached")
    end

    it "Should update the parcel statuses" do
      scheduled_job
      expect(booking.parcels.first.reload.status).to eq("delivered")
    end
  end
end
