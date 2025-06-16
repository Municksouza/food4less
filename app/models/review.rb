class Review < ApplicationRecord
  belongs_to :order
  belongs_to :store
  belongs_to :customer
  belongs_to :product

  validates :title, presence: true, length: { maximum: 255 }
  validates :comment, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end