class FlightLoad < ActiveRecord::Base
  belongs_to :route
  belongs_to :fare_routing, dependent: :destroy

end
