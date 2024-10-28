class Order < ApplicationRecord
  belongs_to :user
  belongs_to :package

  enum status: {
    pending: 0,
    paid: 1,
    failed: 2
  }
end
