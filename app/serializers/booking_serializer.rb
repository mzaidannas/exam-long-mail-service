class BookingSerializer
  include JSONAPI::Serializer
  attributes :id, :status
  attribute :current_line do |booking|
    booking.line
  end
  attribute :departure do |booking|
    booking.created_at
  end
  has_many :parcels
end
