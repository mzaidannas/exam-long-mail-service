class BookingParcel < ApplicationRecord
  belongs_to :booking
  belongs_to :parcel
end
