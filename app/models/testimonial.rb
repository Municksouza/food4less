class Testimonial < ApplicationRecord
    has_one_attached :image

  scope :visible, -> { where(visible: true) }
end
