class TurnController < ApplicationController

  def game_flights game_id
    airlines = []
    Airline.where(game_id:game_id).each do |airline|
     airlines.push(airline.id) 
    end
    flights = Flight.where('airline_id IN (?)',airlines).order('route_id DESC')
    organize_flights flights
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
    routes.each do |route|
      process_route route
    end
  end

  def process_route route
    route.each do |flight|
      configuration = flight.user_aircraft.aircraft_configuration
      seats = configuration.config_details[:config]
    end
  end

end