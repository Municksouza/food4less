class Product < ApplicationRecord
  belongs_to :store
  belongs_to :category, optional: true
  
  has_many :order_items
  has_many :reviews, dependent: :nullify
  has_many :orders, through: :order_items
  has_many :customers, through: :orders
  # Removed invalid association: a product already belongs to a single store

  has_many_attached :images

  validates :category, presence: true
  validates :name, :description, :stock, presence: true
  validates :old_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  # Removed validation for discount_price as it is a method, not a database column
  
  def discount_price
    return 0 if old_price.blank? || old_price <= price
    (old_price - price).round(2)
  end
end