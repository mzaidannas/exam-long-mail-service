class BookTrainJob
  include Sidekiq::Job

  def perform(train_id, user_id)
    train = Train.find(train_id)
    user = User.find(user_id)
    booking = TrainBookingService.new(train, user).fill_train
    return false if booking.nil?
    TrainReachedJob.perform_at(booking.end_time, booking.id)
    true
  end
end
