class Airline < ActiveRecord::Base
  belongs_to :user
  has_one :alliance_membership
  has_one :alliance, through: :alliance_membership

  validates :name, :icao, :user_id, :game_id, :money, presence: true
end
