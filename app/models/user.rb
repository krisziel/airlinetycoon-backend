class User < ActiveRecord::Base
  has_many :airlines

  has_secure_password
  validates :name, :username, :password, :email, presence: true
  validates :username, :email, uniqueness: true
end
