class Business < ApplicationRecord
  belongs_to :user
  has_many :stores, dependent: :destroy

  validates :name, :phone, :address, :zip_code, :logo, presence: true
end