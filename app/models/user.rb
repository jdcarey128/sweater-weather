class User < ApplicationRecord
  before_validation :generate_api_key
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :password, require: true 
  validates :api_key, presence: true, uniqueness: true 
  
  has_secure_password

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
