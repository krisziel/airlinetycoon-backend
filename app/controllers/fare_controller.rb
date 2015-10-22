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
    nonstop = airline.flights.find_by(route_id:Route.where("(origin_id=? AND destination_id=?) OR (origin_id=? AND destination_id=?)", origin, destination, destination, origin))
    route_id = nonstop ? nonstop.route_id : 0
    origin_pairs = get_destinations origin, route_id
    destination_pairs = get_destinations destination, route_id
    routes = origin_pairs[:airports] & destination_pairs[:airports]
    route_list = []
    origin_pairs[:airports].each_with_index do |airport, index|
      if origin_pairs[:routes][index] == route_id
        origin_pairs[:routes].delete(route_id)
        origin_pairs[:airports].delete(airport)
        next
      end
      flight = airline.flights.where("route_id != ?", (nonstop ? nonstop.route_id : 0)).find_by(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_pairs[:airports], destination_pairs[:airports], airport))
      if flight
        origin = flight.route.origin_id
        outbound = origin_pairs[:airports].index(airport)
        inbound = destination_pairs[:airports].index(origin == airport ? flight.route.destination_id : origin)
        pair = [origin_pairs[:routes][outbound], flight.route_id, destination_pairs[:routes][inbound]]
        route_list.push(pair)
        routes.delete(airport)
      end
    end
    routes.each do |route|
      outbound = origin_pairs[:airports].index(route)
      inbound = destination_pairs[:airports].index(route)
      pair = [origin_pairs[:routes][outbound], destination_pairs[:routes][inbound]]
      route_list.unshift(pair)
    end
    if nonstop
      route_list.unshift([nonstop.route_id])
    end
    return route_list.uniq
  end

  def get_destinations airport, route_id
    airline = Airline.find(3)
    flights = airline.flights.where(route_id:Route.where("origin_id = ? OR destination_id = ? AND id != ?", airport, airport, route_id))
    airport_list = []
    route_list = []
    flights.each do |flight|
      dest = flight.route.destination_id
      airport_list.push(dest == airport ? flight.route.origin_id : dest)
      route_list.push(flight.route.id)
    end
    return { airports:airport_list, routes:route_list }
  end

end
# Flight.last.update(airline_id:3)
