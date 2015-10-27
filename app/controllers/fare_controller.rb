class FareController < ApplicationController
  before_action :game, :airline

  def show
    airline = Airline.find(3)
    if airline
      routings_data = get_routings params[:o], params[:d]
      route_data = extract_routes routings_data
      data = {
        airports:route_data[:airports],
        routes:route_data[:routes],
        routings:routings_data
      }
    end
    render json: data
  end

  def create

  end

  def routes
    id = params[:route_id]
    route = Route.find(id)
    routings = get_routings route.origin_id, route.destination_id
    routings.each do |route|
      airports = route

    end
  end

  private

  def extract_routes routings
    routes = {}
    airports = {}
    puts "%%%%%%%%%%%%%%%% #{routings}"
    routings.each do |routing|
      routing.each do |route_id|
        route = Route.find(route_id)
        routes[route_id] = route_info route
        airports[route.origin_id] = route.origin.basic_data
        airports[route.destination_id] = route.destination.basic_data
      end
    end
    {
      routes:routes,
      airports:airports
    }
  end

  def route_info route
    airline = Airline.find(3)
    flights = route.flights.where(airline_id: airline)
    route_info = {
      capacity:get_route_capacity(flights),
      origin:route.origin_id,
      destination:route.destination_id
    }
    route_info
  end

  def get_route_capacity flights
    capacity = {
      :y => 0,
      :p => 0,
      :j => 0,
      :f => 0
    }
    flights.each do |flight|
      capacity = add_capacity(capacity, flight.frequencies, flight.user_aircraft.aircraft_configuration)
    end
    capacity
  end

  def add_capacity existing, frequencies, flight
    existing[:y] += flight.y_count*frequencies
    existing[:p] += flight.p_count*frequencies
    existing[:j] += flight.j_count*frequencies
    existing[:f] += flight.f_count*frequencies
    existing
  end

  def get_routings origin, destination
    nonstop = airline.flights.find_by(route_id:Route.where("(origin_id=? AND destination_id=?) OR (origin_id=? AND destination_id=?)", origin, destination, destination, origin))
    route_id = nonstop ? nonstop.route_id : 0
    origin_pairs = get_destinations origin, route_id
    destination_pairs = get_destinations destination, route_id
    route_list = []
    origin_pairs.each do |airport, route|
      if destination_pairs[airport]
        route_list.push([route, destination_pairs[airport]])
      end
      flights = airline.flights.where("route_id != ?", (nonstop ? nonstop.route_id : 0)).where(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_pairs.keys, destination_pairs.keys, airport))
      flights.each do |flight|
        origin = flight.route.origin_id
        dest = flight.route.destination_id
        connection = (origin == airport ? dest : origin)
        puts origin
        puts "$$$$$$$$$$$$$$ #{connection} $$$$$$$$$$$$$$$$$"
        puts dest
        puts destination_pairs
        route_list.push([route, flight.route.id, destination_pairs[connection]])
      end
    end
    if nonstop
      route_list.unshift([nonstop.route_id])
    end
    return route_list.uniq
  end

  def get_destinations airport, route_id
    flights = airline.flights.where(route_id:Route.where("(origin_id = ? OR destination_id = ?) AND id != ?", airport, airport, route_id))
    airport_list = []
    route_list = []
    return_data = {}
    flights.each do |flight|
      dest = flight.route.destination_id
      origin = flight.route.origin_id
      origin == airport.to_i ? airport_id = dest : airport_id = origin
      return_data[airport_id] = flight.route.id
      # airport_list.push(airport_id)
      # route_list.push(flight.route.id)
    end
    # return_data = { airports:airport_list.uniq, routes:route_list.uniq }
    puts return_data
    return return_data
  end

end
