class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :photo 
  has_one :cart
  has_many :orders
  has_many :receipts, through: :orders
  has_many :payments, through: :orders
  has_many :stores, through: :orders
  has_many :products, through: :stores
  has_many :reviews

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true

  def avatar_url
    if photo.attached?
      Rails.application.routes.url_helpers.url_for(photo)
    else
      "/assets/images/default-avatar.png"  # Caminho da imagem padrão
    end
  end
end
