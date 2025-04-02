class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :store

  validates :payment_method, :status, :transaction_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
end