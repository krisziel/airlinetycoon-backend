class FareController < ApplicationController
  before_action :game, :airline

  private

  def get_routings origin, destination
    origin_destinations = get_destinations origin
    destination_destinations = get_destinations destination
    routes = []
    origin_destinations.each do |airport|
      routes.push()
    end
  end

  def get_destinations iata
    airport = Airport.find_by(iata:iata)
    airline = Airline.find(1)
    flights = airline.flights.where(route_id:Route.where("origin_id = ? OR destination_id = ?", airport.id, airport.id))
    destination_list = []
    flights.each do |flight|
      if flight.route.origin_id = airport.id
        destination_list.push(flight.route.destination_id)
      else
        destination_list.push(flight.route.origin_id)
      end
    end
    return destination_list.uniq
  end

end
