class Booking < ApplicationRecord
  belongs_to :postmaster, class_name: "User", foreign_key: "user_id"
  belongs_to :train
  has_many :booking_parcels
  has_many :parcels, through: :booking_parcels

  after_create :booking_created
  after_update :booking_updated

  private

  def booking_created
    Line.find_by(name: line).update(booked: true)
    train.update(status: "booked")
    parcels.update_all("status = 'picked', train_id = #{train.id}, cost = weight * #{train.cost_per_kg}")
  end

  def booking_updated
    Line.find_by(name: line).update(booked: true)
    train.update(status: "booked")
    parcels.update_all(status: "picked", train_id: train.id)
  end
end
