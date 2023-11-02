class TrainReachedJob
  include Sidekiq::Job

  def perform(booking_id)
    booking = Booking.find(booking_id)
    ActiveRecord::Base.transaction do
      Line.find_by(name: booking.line).update(booked: false)
      booking.train.update(status: "reached")
      booking.parcels.update_all(status: "delivered")
    end
  end
end
