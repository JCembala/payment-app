class Order < ApplicationRecord
  belongs_to :user
  belongs_to :package

  enum status: {
    pending: 0,
    paid: 1,
    failed: 2
  }

  validates :stripe_session_id, presence: true
  validates :status, presence: true
end
