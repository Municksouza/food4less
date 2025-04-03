class Refund < ApplicationRecord
  belongs_to :order
  belongs_to :store
  belongs_to :customer, optional: true
  belongs_to :business_admin, optional: true

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :refund_date, presence: true
end

