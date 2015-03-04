class AircraftConfiguration < ActiveRecord::Base
  belongs_to :aircraft
  belongs_to :airline
  validates :name, uniqueness: {scope: [:airline_id, :aircraft_id], message:"A configuration with the same name already exists for this aircraft"}
end
