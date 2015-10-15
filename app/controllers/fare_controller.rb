class FareController < ApplicationController
  before_action :game, :airline

  private

  def get_routings origin, destination
    origin_destinations = get_destinations origin
    destination_destinations = get_destinations destination
    routes = origin_destinations & destination_destinations
    airline = Airline.find(1)
    origin_destinations.each do |airport|
      flights = airline.flights.where(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_destinations, destination_destinations, airport))
      routes.push(flights)
    end
    return routes
  end

  def get_destinations iata
    airport = Airport.find_by(iata:iata)
    airline = Airline.find(1)
    flights = airline.flights.where(route_id:Route.where("origin_id = ? OR destination_id = ?", airport.id, airport.id))
    destination_list = []
    flight_list = []
    flights.each do |flight|
      flight_list.push(flight.id)
      destination_list.push(flight.route.destination_id)
      destination_list.push(flight.route.origin_id)
    end
    return destination_list
  end

end
