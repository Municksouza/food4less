class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :photo
  has_many :orders
  has_many :stores, through: :orders
  has_many :products, through: :stores

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
