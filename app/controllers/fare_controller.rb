class FareController < ApplicationController
  before_action :game, :airline

  def routes
    id = params[:route_id]
    route = Route.find(id)
    routings = get_routings route.origin_id, route.destination_id
    routings.each do |route|
      airports = route

    end
  end

  def show

  end

  private

  def get_routings origin, destination
    airline = Airline.find(3)
    origin_destinations = get_destinations origin
    destination_destinations = get_destinations destination
    routes = origin_destinations[:destinations] & destination_destinations[:destinations]
    origin_destinations[:destinations].each do |airport|
      flight = airline.flights.find_by(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_destinations[:destinations], destination_destinations[:destinations], airport))
      if flight
        origin = flight.route.origin_id
        outbound = origin_destinations[:destinations].index(airport)
        inbound = destination_destinations[:destinations].index(origin == airport ? flight.route.destination_id : origin)
        pair = [origin_destinations[:routes][outbound], flight.route_id, destination_destinations[:routes][inbound]]
        routes.push(pair)
      end
    end
    route_list = []
    routes.each_with_index do |route, index|
      if route.class == Array
        route_list.push(route)
      else
        outbound = origin_destinations[:destinations].index(route)
        inbound = destination_destinations[:destinations].index(route)
        pair = [origin_destinations[:routes][outbound], destination_destinations[:routes][inbound]]
        route_list.push(pair)
      end
    end
    return route_list.uniq
  end

  def get_destinations airport
    airline = Airline.find(3)
    flights = airline.flights.where(route_id:Route.where("origin_id = ? OR destination_id = ?", airport, airport))
    destination_list = []
    route_list = []
    flights.each do |flight|
      dest = flight.route.destination_id
      destination_list.push(dest == airport ? flight.route.origin_id : dest)
      route_list.push(flight.route.id)
    end
    return { destinations:destination_list, routes:route_list }
  end

end
