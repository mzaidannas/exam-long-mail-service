class Parcel < ApplicationRecord
  attr_accessor :marked

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  belongs_to :train, optional: true
  enum statuses: {pending: "pending", picked: "picked", delivered: "delivered", retrieved: "retrieved"}

  def >(other)
    weight > other.weight
  end

  def <(other)
    weight > other.weight
  end
end
