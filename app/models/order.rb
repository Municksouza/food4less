class Order < ApplicationRecord
  belongs_to :store
  belongs_to :customer, class_name: "User"
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy

  validates :status, :total_price, presence: true
end