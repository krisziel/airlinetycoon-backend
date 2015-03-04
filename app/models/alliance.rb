class Alliance < ActiveRecord::Base
  belongs_to :game
  has_many :airlines, through: :alliance_memberships
  has_many :alliance_memberships
  validates :name, uniqueness: {scope: :game_id, message:'An alliance with that name already exists'}
end
