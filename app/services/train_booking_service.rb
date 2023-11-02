class TrainBookingService
  def initialize(train, user)
    @train = train
    @user = user
  end

  def fill_train
    booking = nil
    ActiveRecord::Base.transaction do
      @lines = Line.where(booked: false, name: @train.lines)
      @parcels = Parcel.where(status: "pending").order(:weight)

      raise ActiveRecord::Rollback if @lines.empty? || @parcels.empty?

      booking = Booking.new(train_id: @train.id, user_id: @user.id, line: @lines.sample.name)
      @parcels.find_each do |parcel|
        break if @train.weight <= 0 || @train.volume <= 0
        if parcel.weight <= @train.weight && (parcel.volume / 1e6) <= @train.volume
          @train.weight -= parcel.weight
          @train.volume -= (parcel.volume / 1e6)
          booking.parcels << parcel
        end
      end
      booking.save!
    end
    booking.reload
  end
end
