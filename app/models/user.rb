class User < ApplicationRecord
  before_validation :generate_api_key
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  
  has_secure_password

  private 

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
