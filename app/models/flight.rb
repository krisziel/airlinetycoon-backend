class Flight < ActiveRecord::Base
  belongs_to :route
  belongs_to :airline
  belongs_to :user_aircraft
end
