require "rails_helper"

describe BookTrainJob, type: :job do
  let(:user) { create(:user, :postmaster) }
  let(:train) { create(:train) }
  let(:parcels) { create_list(:parcel, 10, train: train) }
  let(:booking) { create(:booking, train: train, postmaster: user, parcels: parcels) }
  let(:book_mock) { double(:booking) }
  let(:scheduled_job) { described_class.perform_async(train.id, user.id) }
  describe "Test Booking" do
    before :each do
      LINES.each { |line| Line.create(name: line, booked: false) }
    end

    it "Should book a train" do
      scheduled_job
      expect(described_class.queue).to eq("default")
    end

    it "creates a booking and schedule a job for train reaching time" do
      allow(TrainBookingService).to receive(:new).and_return(book_mock)
      allow(book_mock).to receive(:fill_train).and_return(booking)
      expect { scheduled_job }.to change { described_class.jobs.size }.by(1)
      described_class.new.perform(train.id, user.id)
      expect(TrainReachedJob).to have_enqueued_sidekiq_job(booking.id).at(booking.end_time)
    end

    context "occurs daily" do
      it "occurs at expected time" do
        scheduled_job
        expect(described_class.jobs.last["jid"]).to include(scheduled_job)
        expect(described_class).to have_enqueued_sidekiq_job(train.id, user.id)
      end
    end
  end
end
