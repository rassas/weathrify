class City < ApplicationRecord
  belongs_to :user

  validates :lat, :lng, :name, presence: true
end
