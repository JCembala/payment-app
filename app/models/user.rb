class User < ApplicationRecord
  has_many :orders
  has_one :latest_order, -> { order(created_at: :desc) }, class_name: 'Order'
  has_one :package, through: :latest_order

  validates :email, presence: true, uniqueness: true
end
