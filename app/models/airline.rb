class Airline < ActiveRecord::Base
  belongs_to :user
  has_one :alliance_membership
  has_one :alliance, through: :alliance_membership

  validates :name, :icao, :user_id, :game_id, presence: true
  validates :name, uniqueness: {scope: :game_id, message:'An airline with that name already exists'}
  validates :icao, uniqueness: {scope: :game_id, message:'An airline with that icao code already exists'}
end
