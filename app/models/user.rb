class User < ApplicationRecord
  has_secure_password

  has_many :tokens, dependent: :destroy
  has_many :cities, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
