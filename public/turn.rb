# class TurnController < ApplicationController
class Turn

  def initialize
    @elasticity = {
      [1.25,10] => {
        base:0.4509,
        margin:1.009,
        anchor:1.25
      },
      [1.01,1.24] => {
        base:0.0,
        margin:1.015,
        anchor:1.0
      },
      [1,1] => {
        base:0.0,
        margin:1,
        anchor:1.0
      },
      [0.9,1] => {
        base:0.0,
        margin:0.994,
        anchor:1.0
      },
      [0.7,0.89] => {
        base:-0.0584,
        margin:0.975,
        anchor:0.9
      },
      [0,0.69] => {
        base:-0.4325,
        margin:0.95,
        anchor:0.7
      }
    }
  end
  @routes = {}

  def game_flights game_id
    airlines = []
    Airline.where(game_id:game_id).each do |airline|
     airlines.push(airline.id) 
    end
    flights = Flight.where('airline_id IN (?)',airlines).order('route_id DESC')
    organize_flights flights
    ''
  end

  def organize_flights flights
    routes = {}
    flight_routes = {}
    flights.each do |flight|
      if routes[flight.route_id]
        flight_routes[flight.route_id].push(flight)
      else
        route = flight.route
        routes[flight.route_id] = route
        flight_routes[flight.route_id] = [flight]
      end
    end
    @routes = flight_routes
    reformatted_routes = []
    routes.each do |id,route|
      flights = process_route flight_routes[id]
      route = {
        :flights => flights,
        :route => reformat_route(route)
      }
      reformatted_routes.push(route)
    end
    reformatted_routes
  end

  def process_route route
    flights = []
    route.each do |flight|
      flight = reformat_flight flight
      flights.push(flight)
    end
    flights
  end

  def reformat_route route
    price = route.price
    demand = route.demand
    route = {
      :id => route.id,
      :cabins => {
        :f => {
          :fare => price["f"],
          :demand => demand["f"]
        },
        :j => {
          :fare => price["j"],
          :demand => demand["j"]
        },
        :p => {
          :fare => price["p"],
          :demand => demand["p"]
        },
        :y => {
          :fare => price["y"],
          :demand => demand["y"]
        }
      }
    }
    route
  end

  def reformat_flight flight
    configuration = flight.user_aircraft.aircraft_configuration
    layout = configuration.config_details[:config]
    fares = flight.fare
    flight = {
      :id => flight.id,
      :cabins => {
        :f => {
          :fare => fares["f"],
          :count => layout[:f][:count]
        },
        :j => {
          :fare => fares["j"],
          :count => layout[:j][:count]
        },
        :p => {
          :fare => fares["p"],
          :count => layout[:p][:count]
        },
        :y => {
          :fare => fares["y"],
          :count => layout[:y][:count]
        }
      }
    }
    flight
  end

  def price_spread market, fare
    demand = {
      :spread => 1.0,
      :elasticity => {},
      :percent => 0,
      :multiplier => 1
    }
    market = market.to_f
    fare = fare.to_f
    spread = (market-fare)/market
    demand[:spread] = spread.round(4)
    demand[:percent] = (demand[:spread].abs*100).round
    @elasticity.each do |key,value|
      if (1.0+demand[:spread]).between?(key[0],key[1])
        demand[:elasticity] = value
      end
    end
    demand[:multiplier] = compute_multiplier demand
    demand
  end

  def compute_multiplier demand
    exponent = ((1.0+demand[:spread])-demand[:elasticity][:anchor])
    exponent = (exponent*100).abs.floor.to_i
    multiplier = (demand[:elasticity][:margin]**exponent)+demand[:elasticity][:base]
    multiplier = multiplier.round(4)
    multiplier
  end

  def compare_demand route
    flights = route
    total_capacity = {
      :f => {},
      :j => {},
      :p => {},
      :y => {},
      :total => {}
    }
  end

end