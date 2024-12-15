class User < ApplicationRecord
  has_secure_password

  has_many :tokens, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
