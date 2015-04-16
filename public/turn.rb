# class TurnController < ApplicationController
class Turn

  def initialize
    @elasticity = {
      [1.25,100.0] => {
        base:0.4509,
        margin:1.009,
        anchor:1.25
      },
      [1.0,1.25] => {
        base:0.0,
        margin:1.015,
        anchor:1.0
      },
      [1.0,1.0] => {
        base:0.0,
        margin:1,
        anchor:1.0
      },
      [0.9,1.0] => {
        base:0.0,
        margin:0.994,
        anchor:1.0
      },
      [0.7,0.9] => {
        base:-0.0584,
        margin:0.975,
        anchor:0.9
      },
      [-100.0,0.7] => {
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
      route = {
        :route => reformat_route(route)
      }
      flights = process_route({
        :flights => flight_routes[id],
        :market => route[:route][:cabins]
      })
      route[:flights] = flights
      reformatted_routes.push(route)
    end
    reformatted_routes
    @compare = reformatted_routes[3]
  end

  def process_route route
    flights = []
    route[:flights].each do |flight|
      flight = reformat_flight(flight,route[:market])
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

  def reformat_flight flight, market
    configuration = flight.user_aircraft.aircraft_configuration
    layout = configuration.config_details[:config]
    fares = flight.fare
    flight = {
      :id => flight.id,
      :cabins => {
        :f => {
          :fare => fares["f"],
          :count => layout[:f][:count],
          :pricing => price_spread(market[:f][:fare],fares["f"])
        },
        :j => {
          :fare => fares["j"],
          :count => layout[:j][:count],
          :pricing => price_spread(market[:j][:fare],fares["j"])
        },
        :p => {
          :fare => fares["p"],
          :count => layout[:p][:count],
          :pricing => price_spread(market[:p][:fare],fares["p"])
        },
        :y => {
          :fare => fares["y"],
          :count => layout[:y][:count],
          :pricing => price_spread(market[:y][:fare],fares["y"])
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
    if market && fare
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
      demand[:multiplier] = compute_multiplier(demand)
    end
    demand
  end

  def compute_multiplier demand
    exponent = ((1.0+demand[:spread])-demand[:elasticity][:anchor])
    exponent = (exponent*100).abs.floor.to_i
    multiplier = (demand[:elasticity][:margin]**exponent)+demand[:elasticity][:base]
    multiplier = multiplier.round(4)
  end

  def sort_fares route
    sorted_fares = {
      f:[],
      j:[],
      p:[],
      y:[]
    }
    route[:flights].each do |flight|
      reformat = reform_sort_flight flight
      sorted_fares[:f].push(reformat[:f])
      sorted_fares[:j].push(reformat[:j])
      sorted_fares[:p].push(reformat[:p])
      sorted_fares[:y].push(reformat[:y])
    end
    sorted_fares[:f].sort_by {|_key, value| value[:fare]}
    sorted_fares[:j].sort_by {|_key, value| value[:fare]}
    sorted_fares[:p].sort_by {|_key, value| value[:fare]}
    sorted_fares[:y].sort_by {|_key, value| value[:fare]}
    sorted_fares
  end

  def reform_sort_flight flight
    reformat = {
      f:{},
      j:{},
      p:{},
      y:{}
    }
    flight[:cabins].each do |key,cabin|
      reformat[key] = {
        :id => flight[:id],
        :fare => cabin[:fare],
        :pricing => cabin[:pricing],
        :count => cabin[:count]
      }
    end
    reformat
  end
  # {:id=>48, :cabins=>{:f=>{:fare=>4535, :count=>10, :pricing=>{:spread=>0.2709, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25},
  # :percent=>27, :multiplier=>1.469}}, :j=>{:fare=>1948, :count=>58, :pricing=>{:spread=>0.5824, :elasticity=>{:base=>0.4509, :margin=>1.009,
  #   :anchor=>1.25}, :percent=>58, :multiplier=>1.7949}}, :p=>{:fare=>605, :count=>63, :pricing=>{:spread=>0.7359, :elasticity=>{:base=>0.4509,
  #     :margin=>1.009, :anchor=>1.25}, :percent=>74, :multiplier=>1.9883}}, :y=>{:fare=>672, :count=>232, :pricing=>{:spread=>0.3984,
  #       :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>40, :multiplier=>1.5845}}}}
  def compare_demand route

  end

end