class Order < ApplicationRecord
  belongs_to :store
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy

  STATUSES = %w[pending accepted rejected]

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  # Instance methods
  def accept!
    update(status: 'accepted')
  end

  def reject!
    update(status: 'rejected')
  end

  def pending?
    status == 'pending'
  end
end