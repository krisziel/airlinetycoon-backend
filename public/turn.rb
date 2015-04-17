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
  @flights = {}

  def game_flights game_id
    airlines = []
    Airline.where(game_id:game_id).each do |airline|
     airlines.push(airline.id) 
    end
    flights = Flight.where('airline_id IN (?)',airlines).order('route_id DESC')
    organized_routes = organize_flights flights
    @flights = organized_routes
    organized_routes.each do |key,route|
    end
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
      if route[:flights][0][:route_id] == 1186
        @flights2 = route
      end
      reformatted_routes.push(route)
    end
    reformatted_routes
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
          :fare => fares["f"].to_i,
          :count => (layout[:f][:count]*flight.frequencies)/7).round,
          :pricing => price_spread(market[:f][:fare],fares["f"])
        },
        :j => {
          :fare => fares["j"].to_i,
          :count => (layout[:j][:count]*flight.frequencies)/7).round,
          :pricing => price_spread(market[:j][:fare],fares["j"])
        },
        :p => {
          :fare => fares["p"].to_i,
          :count => (layout[:p][:count]*flight.frequencies)/7).round,
          :pricing => price_spread(market[:p][:fare],fares["p"])
        },
        :y => {
          :fare => fares["y"].to_i,
          :count => (layout[:y][:count]*flight.frequencies)/7).round,
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
  # {:fare=>7228, :count=>10, :pricing=>{:spread=>0.3874, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>39, :multiplier=>1.5744}}, :j=>{:fare=>3105, :count=>58, :pricing=>{:spread=>0.6492, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>65, :multiplier=>1.8692}}, :p=>{:fare=>964, :count=>63, :pricing=>{:spread=>0.7246, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>72, :multiplier=>1.9745}}, :y=>{:fare=>1071, :count=>232, :pricing=>{:spread=>0.1959, :elasticity=>{:base=>0.0, :margin=>1.015, :anchor=>1.0}, :percent=>20, :multiplier=>1.327}}}}, {:id=>1, :cabins=>{:f=>{:fare=>7228, :count=>10, :pricing=>{:spread=>0.3874, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>39, :multiplier=>1.5744}}, :j=>{:fare=>3105, :count=>54, :pricing=>{:spread=>0.6492, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>65, :multiplier=>1.8692}}, :p=>{:fare=>964, :count=>90, :pricing=>{:spread=>0.7246, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>72, :multiplier=>1.9745}}, :y=>{:fare=>1071, :count=>230, :pricing=>{:spread=>0.1959, :elasticity=>{:base=>0.0, :margin=>1.015, :anchor=>1.0}, :percent=>20, :multiplier=>1.327}}}}, {:id=>83, :cabins=>{:f=>{:fare=>"6120", :count=>7, :pricing=>{:spread=>0.4813, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>48, :multiplier=>1.6797}}, :j=>{:fare=>"3037", :count=>42, :pricing=>{:spread=>0.6568, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>66, :multiplier=>1.8819}}, :p=>{:fare=>"1851", :count=>55, :pricing=>{:spread=>0.4711, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>47, :multiplier=>1.6688}}, :y=>{:fare=>"750", :count=>201, :pricing=>{:spread=>0.4369, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>44, :multiplier=>1.6259}}}}]}
  # [{:id=>1, :cabins=>{:f=>{:fare=>7228, :count=>10, :pricing=>{:spread=>0.3874, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>39, :multiplier=>1.5744}}, :j=>{:fare=>3105, :count=>54, :pricing=>{:spread=>0.6492, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>65, :multiplier=>1.8692}}, :p=>{:fare=>964, :count=>90, :pricing=>{:spread=>0.7246, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>72, :multiplier=>1.9745}}, :y=>{:fare=>1071, :count=>230, :pricing=>{:spread=>0.1959, :elasticity=>{:base=>0.0, :margin=>1.015, :anchor=>1.0}, :percent=>20, :multiplier=>1.327}}}}, {:id=>76, :cabins=>{:f=>{:fare=>7228, :count=>10, :pricing=>{:spread=>0.3874, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>39, :multiplier=>1.5744}}, :j=>{:fare=>3105, :count=>58, :pricing=>{:spread=>0.6492, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>65, :multiplier=>1.8692}}, :p=>{:fare=>964, :count=>63, :pricing=>{:spread=>0.7246, :elasticity=>{:base=>0.4509, :margin=>1.009, :anchor=>1.25}, :percent=>72, :multiplier=>1.9745}}, :y=>{:fare=>1071, :count=>232, :pricing=>{:spread=>0.1959, :elasticity=>{:base=>0.0, :margin=>1.015, :anchor=>1.0}, :percent=>20, :multiplier=>1.327}}}}] 

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
    sorted_fares[:f].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:j].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:p].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:y].sort_by!{|value| value[:fare] }.reverse!
    { :market => route[:route], :fares => sorted_fares }
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
        :multiplier => cabin[:pricing][:multiplier],
        :count => cabin[:count],
        :occupied => 0
      }
    end
    reformat
  end

  def compare_demand route
    route[:fares].each do |key, cabin|
      total_pax = route[:market][:cabins][key.to_sym][:demand]
      airlines = airlines_with_cabin(cabin)
      airlines.each_with_index do |fare, index|
        pax_at_fare = fare[:multiplier]*total_pax.round
        airlines.each_with_index do |airline, i|
          pax_per_airline = pax_at_fare/(airlines.length-i).round
          open_seats = (airline[:count] - airline[:occupied])
          if pax_per_airline > open_seats
            pax_at_fare = pax_at_fare - open_seats
            pax_on_airline = open_seats
          else
            pax_on_airline = pax_per_airline
            pax_at_fare = (pax_at_fare - pax_on_airline)
          end
          airline[:occupied] = pax_on_airline
        end
      end
    end
    route
  end

  def airlines_with_cabin airlines
    airline_list = []
    airlines.each do |cabin|
      if cabin[:count] > 0
        airline_list.push(cabin)
      end
    end
    airline_list
  end

  def distribute_passengers
  end

end