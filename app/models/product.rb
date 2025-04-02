class Product < ApplicationRecord
  belongs_to :store
  has_many :order_items

  has_many_attached :images # Agora as imagens serão salvas no Cloudinary

  validates :name, :description, :stock, presence: true
  validates :old_price, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
end