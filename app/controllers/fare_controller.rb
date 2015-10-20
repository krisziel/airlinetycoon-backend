class FareController < ApplicationController
  before_action :game, :airline

  private
  airline = Airline.find(3)

  def get_routings origin, destination
    origin_destinations = get_destinations origin
    destination_destinations = get_destinations destination
    routes = origin_destinations & destination_destinations
    airline = Airline.find(3)
    origin_destinations.each do |airport|
      flight = airline.flights.find_by(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_destinations, destination_destinations, airport))
      if flight
        origin = flight.route.origin_id
        routes.push([airport, origin == airport ? flight.route.destination_id : origin])
      end
    end
    route_list = []
    routes.each do |route|
      if route.class == "Array"
        route_list.push(route)
      else
        route_list.push([route])
      end
    end
    return route_list.uniq
  end

  def get_destinations iata
    airport = Airport.find_by(iata:iata)
    airline = Airline.find(3)
    flights = airline.flights.where(route_id:Route.where("origin_id = ? OR destination_id = ?", airport.id, airport.id))
    destination_list = []
    flight_list = []
    flights.each do |flight|
      flight_list.push(flight.id)
      dest = flight.route.destination_id
      destination_list.push(dest == airport.id ? flight.route.origin_id : dest)
    end
    puts "DESTINATION LIST"
    puts destination_list
    puts "***********"
    return destination_list
  end

end
