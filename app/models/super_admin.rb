class SuperAdmin < ApplicationRecord
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
