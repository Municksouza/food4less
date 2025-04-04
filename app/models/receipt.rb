class Receipt < ApplicationRecord
  belongs_to :business_admin, optional: true
  belongs_to :product, optional: true
  belongs_to :refund, optional: true
  belongs_to :payment, optional: true
  belongs_to :customer, optional: true
  belongs_to :order, optional: true
  belongs_to :store, optional: true

  # Valid values for receipt_type
  RECEIPT_TYPES = %w[customer store]

  validates :receipt_type, presence: true, inclusion: { in: RECEIPT_TYPES }
  validates :content, presence: true
end