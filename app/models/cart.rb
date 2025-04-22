class Cart < ApplicationRecord
  belongs_to :store
  belongs_to :customer

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :status, presence: true, inclusion: { in: %w[open completed] }
end