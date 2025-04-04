class Review < ApplicationRecord
  belongs_to :order
  belongs_to :store
  belongs_to :customer


  validates :rating, presence: true, inclusion: { in: 1..5 }
end