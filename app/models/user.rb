class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
    :jwt_authenticatable,
    :registerable,
    jwt_revocation_strategy: self
  enum role: {operator: "operator", postmaster: "postmaster", owner: "owner"}

  has_many :trains, dependent: :destroy
  has_many :parcels, dependent: :destroy

  validates :name, presence: true
  validates :role, presence: true
  validates :email, presence: true, email: true

  delegate :can?, :cannot?, to: :policy

  def policy
    @policy ||= ::AccessPolicy.new(self)
  end
end
