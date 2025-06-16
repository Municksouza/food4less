require 'erb'
require 'uri'
require 'net/http'
require 'json'
require 'friendly_id'

class Store < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  belongs_to :business_admin
  belongs_to :cuisine, optional: true
  belongs_to :category, optional: true

  has_one :store_manager, dependent: :destroy
  has_one_attached :logo

  has_many :orders, dependent: :destroy
  has_many :customers, through: :orders
  has_many :payments, dependent: :destroy
  has_many :refunds, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Validations
  validates :name, :address, :description, :email, presence: true
  validates :status, inclusion: { in: %w[active inactive open closed archived] }
  validates :latitude, :longitude, numericality: true, allow_nil: true
  validates :phone, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "must be a valid phone number" }
  validates :zip_code, zipcode: { country_code: :ca }
  validates :zip_code, format: { with: /\A[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d\z/i, message: "must be a valid Canadian postal code" }
  validates :slug, presence: true, uniqueness: true
  validates :receive_notifications, inclusion: { in: [true, false] }
  validate :logo_attached
  validates :address, presence: true, if: -> { Rails.env.production? || Rails.env.development? }

  # Callbacks
  before_validation :generate_slug, on: :create
  before_validation :cast_receive_notifications

  # geocoded_by :address
  after_validation :geocode_address, if: :will_save_change_to_address?

  # Removed duplicate has_one_attached :logo to prevent errors

  # Instance methods
  def to_param
    slug
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def geocode_address
    return if address.blank?

    escaped_address = ERB::Util.url_encode(address)
    uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{escaped_address}.json?access_token=#{ENV['MAPBOX_ACCESS_TOKEN']}")

    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      json = JSON.parse(response.body)
      if json["features"].any?
        self.longitude, self.latitude = json["features"][0]["center"]
      else
        # Try geocoding by zip code
        escaped_zip = ERB::Util.url_encode(zip_code)
        uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{escaped_zip}.json?access_token=#{ENV['MAPBOX_ACCESS_TOKEN']}")
        response = Net::HTTP.get_response(uri)
        if response.is_a?(Net::HTTPSuccess)
          json = JSON.parse(response.body)
          if json["features"].any?
            self.longitude, self.latitude = json["features"][0]["center"]
          else
            Rails.logger.error("No geocoding results for #{address} or #{zip_code}")
          end
        else
          Rails.logger.error("Geocode failed (status #{response.code}) for #{zip_code}")
        end
      end
    else
      Rails.logger.error("Geocode failed (status #{response.code}) for #{address}")
    end
  end

  private

  def validate_geocoding
    if latitude.blank? || longitude.blank?
      errors.add(:address, "could not be geocoded. Please check if the address is valid.")
    end
  end

  def logo_attached
    errors.add(:logo, "must be attached") unless logo.attached?
  end

  def cast_receive_notifications
    self.receive_notifications = ActiveRecord::Type::Boolean.new.cast(receive_notifications)
    true
  end

  def generate_slug
    base = name.to_s.parameterize
    slug_candidate = base
    counter = 1

    while Store.exists?(slug: slug_candidate)
      slug_candidate = "#{base}-#{counter}"
      counter += 1
    end

    self.slug = slug_candidate
  end
end