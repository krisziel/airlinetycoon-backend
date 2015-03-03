class Alliance < ActiveRecord::Base
  has_many :airlines, through: :alliance_memberships
  has_many :alliance_memberships
end
