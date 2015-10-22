class FlightLoad < ActiveRecord::Base
  belongs_to :airline
  belongs_to :flight
  belongs_to :fare
  
end
