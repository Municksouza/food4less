class Store < ApplicationRecord
  belongs_to :business
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders # Relacionamento indireto via pedidos

  validates :name, :address, :phone, :zip_code, :logo, presence: true
end