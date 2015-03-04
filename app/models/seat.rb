class Seat < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :aircraft_configurations
end
