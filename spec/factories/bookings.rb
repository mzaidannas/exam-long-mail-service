FactoryBot.define do
  factory :booking do
    line { LINES.sample }
    end_time { 3.hours.from_now }
    association :postmaster, factory: :user
    association :train, strategy: :create

    after :create do |booking|
      booking.train.update(status: "booked")
      booking.parcels = create_list(:parcel, 3, :picked, train: booking.train)
    end
  end
end
