class Store < ApplicationRecord
  belongs_to :business_admin
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders 

  validates :name, :address, :phone, :zip_code, :logo, presence: true
  validates :logo, presence: true  
  validates :description, presence: true  
  validates :email, presence: true

end