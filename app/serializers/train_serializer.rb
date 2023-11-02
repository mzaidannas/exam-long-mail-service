class TrainSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :cost, :weight, :volume, :status, :created_at
  attribute :time_booked, if: proc { |record| record.booking.present? } do |object|
    object.booking&.created_at&.strftime("%Y-%m-%d %I:%M%p")
  end
  attribute :parcels, if: proc { |record| record.booking.present? } do |object|
    ParcelSerializer.new(object.parcels).serializable_hash[:data].map { |h| h[:attributes] }
  end
end
