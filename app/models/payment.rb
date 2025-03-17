class Payment < ApplicationRecord
  belongs_to :order

  validates :payment_method, :status, :transaction_id, presence: true
end