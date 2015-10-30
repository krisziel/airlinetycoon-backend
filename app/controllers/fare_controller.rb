class FareController < ApplicationController
  before_action :game, :airline

  def show
    if airline
      routings_data = get_routings params[:o], params[:d] # get every possible routing between the two airports
      route_data = extract_routes routings_data # just reformats the data from each route for easier display client side
      data = {
        airports:route_data[:airports],
        routes:route_data[:routes],
        routings:routings_data
      }
    end
    render json: data
  end

  def create
    if airline
      modified_routings = []
      price = JSON.parse(params[:fare]) # price is really the fare
      routings = JSON.parse(params[:routings]) # routings is array of arrays of all route ids selected
      route_id = params[:route_id]
      fare = airline.fares.new(route_id:route_id, fare:price) # create new fare with the fare and route id
      if fare.save
        capacity = fare_capacity routings # grab the total capacity for all selected routings
        routings.each do |routing|
          new_routing = fare.fare_routings.new(routing:routing) # create a new fare routing for each routing within fare
          if new_routing.save
            modified_routings.push(new_routing.id) # push the new fare routing into array for the fare
          end
        end
        fare.update(routings:modified_routings, capacity:capacity)
      elsif fare.errors
        fare = airline.fares.find_by(route_id:route_id)
      end
      render json: fare
    else
      render json: {}
    end
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

  def fare_capacity routings
    routes = {}
    total_capacity = { :f=>0, :j=>0, :p=>0, :y=>0 }
    routings.each do |routing| # for every individual routing
      capacity = { :f=>[], :j=>[], :p=>[], :y=>[], :route=>[] }
      routing.each do |route| # for each route within the routing
        if routes[route] # if the capacity has already been set, that's the avail seats
          route_capacity = routes[route]
        else
          route_capacity = route_capacity route # otherwise, get total capacity on route
          routes[route] = route_capacity # and set the routes hash with it
        end
        route_capacity.each do |cabin, seats| # for each cabin in the route's capacity
          capacity[cabin.to_sym].push(seats) # dump it into an array for that cabin to do .min on later
        end
      end
      total_capacity.each do |cabin, seats| # for each cabin pull out the array to get the minimum
        total_capacity[cabin.to_sym] += capacity[cabin.to_sym].min # route A can't sell more seats than route B has
      end
      routes = route_remaining(routes, routing, capacity) # subtract the seats just added from the pool of avail seats
    end
    total_capacity
  end

  def route_remaining new_routes, routing, capacity
    routing.each do |route| # for each route within the routing
      [:y, :p, :j, :f].each do |cabin| # go through each cabin and
        new_routes[route][cabin] -= capacity[cabin].min # remove the number of seats available on that route
      end
    end
    new_routes
  end

  def route_capacity route
    capacity = { :f=>0, :j=>0, :p=>0, :y=>0, :route=>route } # will hold total seats on route + route id
    flights = airline.flights.where(route_id:route)
    flights.each do |flight|
      flight_capacity = flight.user_aircraft.aircraft_configuration # get the aircraft configuration
      capacity[:f] += (flight.frequencies * flight_capacity.f_count) # and add seats from each cabin to existing seat count
      capacity[:j] += (flight.frequencies * flight_capacity.j_count)
      capacity[:p] += (flight.frequencies * flight_capacity.p_count)
      capacity[:y] += (flight.frequencies * flight_capacity.y_count)
    end
    capacity
  end

  def extract_routes routings
    routes = {}
    airports = {}
    routings.each do |routing| # for each routing array within array of all routings
      routing.each do |route_id| # go through each route within that individual route
        route = Route.find(route_id)
        routes[route_id] = route_info route # get route id, airports, capacity
        airports[route.origin_id] = route.origin.basic_data # put the airport basic info in an array to be returned
        airports[route.destination_id] = route.destination.basic_data # for testing as client side already has full airport list
      end
    end
    {
      routes:routes,
      airports:airports
    }
  end

  def route_info route
    flights = route.flights.where(airline_id: airline)
    route_info = {
      capacity:get_route_capacity(flights),
      origin:route.origin_id,
      destination:route.destination_id
    }
    route_info # just returning reformatted data and getting total route capacity
  end

  def get_route_capacity flights
    capacity = { :y => 0, :p => 0, :j => 0, :f => 0 }
    flights.each do |flight|
      capacity = add_capacity(capacity, flight.frequencies, flight.user_aircraft.aircraft_configuration) # add capacity from each flight to existing capacity
    end
    capacity
  end

  def add_capacity existing, frequencies, flight
    existing[:y] += flight.y_count*frequencies
    existing[:p] += flight.p_count*frequencies
    existing[:j] += flight.j_count*frequencies
    existing[:f] += flight.f_count*frequencies
    existing # add seats from flight to existing capacity and return full capacity
  end

  def get_routings origin, destination
    nonstop = airline.flights.find_by(route_id:Route.where("(origin_id=? AND destination_id=?) OR (origin_id=? AND destination_id=?)", origin, destination, destination, origin)) # get nonstop if there is one
    route_id = nonstop ? nonstop.route_id : 0 # if there isn't a nonstop, set 0 since it is not a route id
    origin_pairs = get_destinations origin, route_id # get all destinations from the route's origin
    destination_pairs = get_destinations destination, route_id # get all destinations from the route's destination
    route_list = []
    origin_pairs.each do |airport, route| # for every destination from the origin
      if destination_pairs[airport] # check if is is also a destination for the route destination
        route_list.push([route, destination_pairs[airport]]) # put the array of the two route ids in the route list array
      end
      flights = airline.flights.where("route_id != ?", (nonstop ? nonstop.route_id : 0)).where(route_id:Route.where("(origin_id=? AND destination_id IN (?)) OR (origin_id IN (?) AND destination_id=?)", airport, destination_pairs.keys, destination_pairs.keys, airport))
      # get flights that aren't the non-stop that are between this airport and every airport served by the route's destination
      flights.each do |flight| # for each flight matching that
        origin = flight.route.origin_id
        dest = flight.route.destination_id
        connection = (origin == airport ? dest : origin) # the connection is between this airport and the airport from the destination list that matches it
        route_list.push([route, flight.route.id, destination_pairs[connection]]) # put the array of all three route ids in the route list array
      end
    end
    if nonstop
      route_list.unshift([nonstop.route_id]) # if there is a nonstop, put it in the front of the array
    end
    return route_list.uniq
  end

  def get_destinations airport, route_id
    flights = airline.flights.where(route_id:Route.where("(origin_id = ? OR destination_id = ?) AND id != ?", airport, airport, route_id)) # get all flights from this airport except non-stop to end point
    airport_list = []
    route_list = []
    return_data = {}
    flights.each do |flight| # for every flight the airport has
      dest = flight.route.destination_id
      origin = flight.route.origin_id
      origin == airport.to_i ? airport_id = dest : airport_id = origin # set the airport_id as the other airport
      return_data[airport_id] = flight.route.id # and then use the airport as the key and the route as the value so no dupe airports/routes in array
    end
    return return_data
  end

end
