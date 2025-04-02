class Store < ApplicationRecord
  belongs_to :business_admin, foreign_key: "business_id"
  has_one_attached :logo
  has_one :store_manager, dependent: :destroy
  
  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders
  has_many :payments, dependent: :destroy
  has_many :refunds, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :receipts

  validates :name, :address, :phone, :zip_code, :logo, presence: true
  validates :description, presence: true  
  validates :email, presence: true

end