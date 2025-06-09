class Report < ApplicationRecord
  belongs_to :store

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def summary
    content.truncate(150)
  end
end
