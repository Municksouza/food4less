class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Enum configuration
  ROLES = %w[customer store_manager business_admin super_admin].freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  def super_admin?
    role == "super_admin"
  end

  def business_admin?
    role == "business_admin"
  end

  def store_manager?
    role == "store_manager"
  end

  def customer?
    role == "customer"
  end
end
