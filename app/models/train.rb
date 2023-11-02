class Train < ApplicationRecord
  enum status: {waiting: "waiting", booked: "booked", reached: "reached", withdrawn: "withdrawn"}
  belongs_to :operator, class_name: "User", foreign_key: "user_id"
  has_one :booking
  has_many :booking_parcels, through: :booking
  has_many :parcels, through: :booking_parcels

  validates :lines, inclusion: {in: LINES, message: "%{value} is not a valid line"}
  validates :cost, numericality: {greater_than: 0}
  validates :weight, numericality: {greater_than: 0}
  validates :volume, numericality: {greater_than: 0}

  def cost_per_kg
    cost / [weight, volume / 139].max
  end

  def operator_name
    operator.name
  end
end
