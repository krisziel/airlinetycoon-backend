class Game < ActiveRecord::Base
  has_many :airlines
  has_many :alliances
  has_many :game_chats
end
