class Store < ApplicationRecord
  belongs_to :business_admin
  has_one_attached :logo
  has_one :store_manager, dependent: :destroy
  
  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders
  has_many :payments, dependent: :destroy
  has_many :refunds, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :receipts
  has_many :reviews
  
  geocoded_by :address
  after_validation :geocode, if: -> { will_save_change_to_address? && (latitude.blank? || longitude.blank?) }

  validates :name, :address, :phone, :zip_code, :logo, presence: true
  validates :status, inclusion: { in: %w[active inactive] }
  validates :description, presence: true  
  validates :email, presence: true
  validates :latitude, :longitude, numericality: true, allow_nil: true
  validates :receive_notifications, inclusion: { in: [true, false] }

end