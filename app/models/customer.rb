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
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates_format_of :password,
    with: /\A(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).+\z/,
    message: "must include at least one letter, one number and one special character",
    allow_nil: true
  
  unless Rails.env.test?
    has_one_attached :photo
  end
  
  def avatar_url
    if photo.attached?
      Rails.application.routes.url_helpers.url_for(photo)
    else
      "/assets/images/default-avatar.png"  
    end
  end
end
