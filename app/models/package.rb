class Package < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }

  def price_dollars
    price_cents / 100
  end
end
