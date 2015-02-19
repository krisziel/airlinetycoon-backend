class User < ActiveRecord::Base
  has_many :airlines
  
  has_secure_password
  validates :name, :username, :password, presence: true
end
