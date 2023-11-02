class ParcelSerializer
  include JSONAPI::Serializer
  attributes :id, :cost, :weight, :volume, :status
end
