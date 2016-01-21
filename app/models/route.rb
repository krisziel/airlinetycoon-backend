class Route < ActiveRecord::Base
  has_many :flights
  has_many :market_sizes, as: :marketable

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

  def serialize_flights game_id
    flight_list = Flight.where(route_id:id)
    flights = []
    flight_list.each do |flight|
      flights.push(flight.route_serialize)
    end
    route_data = {
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare,
      flights:flights,
      distance:distance,
      id:id
    }
    if game_id
      route_data["marketShares"] = market_share_data game_id
    end
    route_data
  end

  def market_share_data game_id
    airport_shares = self.market_sizes.where("airline_id IN (?)", Game.find(game_id).airlines.pluck(:id))
    all_shares = []
    airport_shares.each do |share|
      all_shares.push share.data
    end
    all_shares
  end

end
