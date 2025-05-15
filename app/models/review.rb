class Review < ApplicationRecord
  belongs_to :order
  belongs_to :store
  belongs_to :customer
  belongs_to :product


  validates :rating, presence: true, inclusion: { in: 1..5 }
end