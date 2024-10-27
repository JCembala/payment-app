class Package < ApplicationRecord
  has_many :orders

  def price_dollars
    price_cents / 100
  end
end
