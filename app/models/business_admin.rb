class BusinessAdmin < ApplicationRecord
       # Include default devise modules. Others available are:
       # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
       devise :database_authenticatable, :registerable,
                             :recoverable, :rememberable, :validatable

       has_one_attached :logo
       has_many :receipts, dependent: :destroy
       has_many :stores, dependent: :destroy
       has_many :store_managers, dependent: :destroy

       validates :name, presence: true
       validates :address, presence: true
       validates :zip_code, presence: true
       validates :phone, presence: true
       validates :email, presence: true
       # validates :logo, presence: true  
       validates :business_number,
                                          presence: true,
                                          uniqueness: true,
                                          format: { with: /\A[0-9]{9}\z/, message: "must be a 9-digit Saskatchewan business number" }
       validates :password, presence: true, on: :create
       validates :password, length: { minimum: 8 }, if: -> { password.present? }
       validates_format_of :password,
                                                                             with: /\A(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).+\z/,
                                                                             message: "must include at least one letter, one number and one special character",
                                                                             if: -> { password.present? }

       unless Rails.env.test?
              has_one_attached :logo
       end
end
