class BusinessAdmin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :logo
  has_many :receipts

  has_many :stores

  validates :name, presence: true
  validates :address, presence: true
  validates :zip_code, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :logo, presence: true  
end
