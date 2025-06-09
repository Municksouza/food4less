class StoreManager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :store

  before_validation :cast_receive_notifications

  validates :receive_notifications, inclusion: { in: [true, false] }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates_format_of :password,
    with: /\A(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).+\z/,
    message: "must include at least one letter, one number and one special character"


  private

  def cast_receive_notifications
    self.receive_notifications = ActiveModel::Type::Boolean.new.cast(receive_notifications)
  end
end
