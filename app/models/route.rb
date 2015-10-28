class Route < ActiveRecord::Base
  has_many :flights
  has_many :fares
  has_many :flight_loads

  def origin
    Airport.find(origin_id)
  end

  def destination
    Airport.find(destination_id)
  end

  def serialize
    route = {
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare,
      distance:distance,
      id:id
    }
    route
  end

  def full_data
    route = {
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare,
      demand:demand,
      elasticity:elasticity,
      price:price,
      distance:distance
    }
    route
  end

  def simple
    route = {
      origin:origin.simple,
      destination:destination.simple,
      id:id,
      distance:distance
    }
  end

  def serialize_flights
    flight_list = Flight.where(route_id:id)
    flights = []
    flight_list.each do |flight|
      flights.push(flight.route_serialize)
    end
    route = {
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare,
      flights:flights,
      distance:distance,
      id:id
    }
  end

end
