class FareParser

  def parse_routings id
    fare = Fare.find(id)
    airline = fare.airline
    route = fare.route
    fare_data = [] # will hold a list of all routings for the fare
    routings = fare.fare_routings # all routings that are part of the fare
    routings.each do |routing| # for each routing the fare has
      this_routing = routing.routing # routing is fare routing .routing is array of route ids
      fare_data.push({ # drop the info for each routing in the array
        routing: this_routing, # just the array of route ids
        price: get_routing_price(airline, route.id, this_routing, route.price), # get market pricing for the specific routing
        capacity: get_routing_capacity(airline, route.id, this_routing) # get maximum capacity for the routing
      })
    end
    fare_data
  end

  def get_routing_price airline, route_id, routing, price # get pricing for a routing that will provide full market demand
    nonstop = airline.flights.find_by(route_id:route_id)
    if nonstop
      nonstop_duration = nonstop.duration
    else
      route = Route.find(route_id).select(:distance)
      nonstop_duration = (route.distance/smallestPlane(route.distance).speed.to_f)*60 # get the duration of the flight for the smallest mission capable plane
    end
    # get the duration for every route within the routing and get the shortest flight for each route
    segment_flights = airline.flights.where('route_id IN (?)', routing).select(:duration, :route_id).order(:duration).distinct
    total_duration = segment_flights.inject(0) { |sum, flight| sum + flight.duration } # total duration of all the flights
    # discount the non-stop market fare to account for mileage and layovers
    # get the total duration of the routings, which all flights + 60 minutes for each connection, divide by nonstop to get percentage above market fare
    # take the sqare route of that to discount a bit less than the increase in time taken and then subtract 1 to get the actual discount rate
    discount_rate = (Math.sqrt((total_duration.to_f+((routing.length-1)*60.0))/nonstop_duration)-1)
    prices = {}
    price.each_with_index do |(key,value),index| # for each cabin, discount a bit more based on number cabin
      # add'l reduction = 0% for Y, 5% for P, 10% for J, 15% for F to reflect the increasing value of time
      prices[key] = (price[key]*(1-(discount_rate + (index*0.05)))).round
    end
    prices
  end

  def get_routing_capacity airline, route_id, routing
    # get all flights on a route user_aircraft to get capacity and frequencies to get total weekly capacity
    segment_flights = airline.flights.where('route_id IN (?)', routing).select(:user_aircraft_id, :route_id, :frequencies).order(:route_id)
    capacity = { :y => 99999, :p => 99999,:j => 99999, :f => 99999 } # since we'll call .min, start with something impossibly high
    capacities = {}
    segment_flights.each do |flight|
      route = flight.route_id
      if(!capacities[route]) # if there is not already capacity for this route
        capacities[route] = {:y=>0, :p=>0, :j=>0, :f=>0} # set it to zero
      end
      capacities[route] = add_capacity(capacities[route], flight.frequencies, flight.user_aircraft.aircraft_configuration) # set the capacity to existing + this flight
    end
    capacities.each do |route, segment_capacity| # for each route in capacities
      segment_capacity.each do |cabin, seats| # get for each cabin
        capacity[cabin] = [capacity[cabin], seats].min # get the minimum between existing minimum and this flight so capacity is limited to the smallest capacity route
      end
    end
    capacity
  end

  def add_capacity existing, frequencies, flight # for adding capacity from each subsequent flight on a route
    existing[:y] += flight.y_count*frequencies
    existing[:p] += flight.p_count*frequencies
    existing[:j] += flight.j_count*frequencies
    existing[:f] += flight.f_count*frequencies
    existing
  end

  def smallestPlane distance # returns smallest plane capable of flying a path to compare flight time against multi flight routings
    mission_capable = Aircraft.where('range >= ?', distance).select(:speed, :range).order(:capacity).limit(1) # get the smallest plane that can fly the route
    if mission_capable.length == 0 # if there is a not a suitable aircraft, get the aircraft with the longest range
      mission_capable = Aircraft.order(range: :desc).limit(1)
    end
    mission_capable.first
  end

end
