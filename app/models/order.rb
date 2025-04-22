class Order < ApplicationRecord
  enum :status, {
    pending: 0,
    accepted: 1,
    rejected: 2,
    approved: 3,
    completed: 4,
    on_delay: 5
  }

  belongs_to :store
  belongs_to :customer

  has_one :receipt
  has_one :refund
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :review, dependent: :destroy
  has_many :order_statuses, dependent: :destroy
  has_many :order_histories, dependent: :destroy

  TAX_RATE = 0.1

  validates :status, presence: true
  validates :store_id, :customer_id, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ready_in_minutes, presence: true, if: :accepted?
  validates :countdown_end_time, presence: true, if: :accepted?

  before_validation :set_initial_status, on: :create
  after_create_commit -> { OrderBroadcaster.new(self).broadcast_new }
  accepts_nested_attributes_for :order_items 
  
  scope :recent, -> { order(created_at: :desc) }

  def subtotal
    order_items.sum { |item| item.unit_price * item.quantity }
  end

  def taxes
    subtotal * TAX_RATE
  end

  def total_price
    self[:total_price] || order_items.sum(&:total_price)
  end

  def total_with_taxes
    subtotal + taxes
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def payment_status
    return "No Payment" unless payment
    return "Paid" if payment.amount.to_f >= total_price.to_f
    return "Partial" if payment.amount.to_f > 0
    "Unpaid"
  end

  def calculated_countdown_end_time
    return nil unless accepted? && ready_in_minutes.present?
    updated_at + ready_in_minutes.minutes
  end

  private

  def set_initial_status
    self.status ||= 'pending'
  end

end