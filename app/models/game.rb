class Game < ActiveRecord::Base
  has_many :airlines
  has_many :alliances
end
