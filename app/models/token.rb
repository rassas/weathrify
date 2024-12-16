class Token < ApplicationRecord
  belongs_to :user

  has_secure_token

  before_create :set_expiration_time

  def set_expiration_time
    self.expires_at = 30.days.from_now
  end

  def expired?
    expires_at && Time.current > expires_at
  end
end
