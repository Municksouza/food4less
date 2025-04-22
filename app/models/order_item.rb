class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    (unit_price || 0) * (quantity || 0)
  end
end