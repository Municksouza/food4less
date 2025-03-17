class Product < ApplicationRecord
  belongs_to :store
  has_many :order_items

  has_many_attached :images # Agora as imagens serão salvas no Cloudinary

  validates :name, :description, :price, :old_price, :stock, presence: true
end