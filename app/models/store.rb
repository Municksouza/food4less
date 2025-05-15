class Store < ApplicationRecord
  belongs_to :business_admin
  belongs_to :cuisine, optional: true
  belongs_to :category, optional: true
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

  after_validation :geocode_address, if: -> { address_changed? && (latitude.blank? || longitude.blank?) }

  def geocode_address
    return if address.blank?

    url = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(address)}.json?access_token=#{ENV['MAPBOX_ACCESS_TOKEN']}")
    res = Net::HTTP.get_response(url)
    json = JSON.parse(res.body)
    
    if json["features"].any?
      self.longitude, self.latitude = json["features"][0]["center"]
    end
  end
end