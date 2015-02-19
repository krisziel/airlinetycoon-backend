class Airline < ActiveRecord::Base
  belongs_to :user

  validates :name, :icao, :user_id, :game_id, :money, presence: true
end
