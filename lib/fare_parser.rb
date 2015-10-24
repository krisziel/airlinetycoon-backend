class FareParser

  def parse_routings id
    fare = Fare.find(id)
    airline = fare.airline
    route = fare.route
    routes_data = []
    routings = fare.routing
    routings.each do |routing|
      duration = (route.distance/smallestPlane(route.distance).speed.to_f)*60
      routes_data.push({
        routing: routing,
        price: get_routing_price(airline, route.price, duration, routing),
        capacity: get_routing_capacity(airline, route.id, routing)
      })
    end
    routes_data
  end

  def get_routing_price airline, price, nonstop_duration, routing
    segment_flights = airline.flights.where('route_id IN (?)', routing).select(:duration, :route_id).order(:duration).distinct
    total_duration = segment_flights.inject(0) { |sum, flight| sum + flight.duration }
    discount_rate = (Math.sqrt((total_duration.to_f+((routing.length-1)*60))/nonstop_duration)-1)
    prices = {}
    price.each_with_index do |(key,value),index|
      prices[key] = (price[key]*(1-(discount_rate + (index*0.05)))).round
    end
    prices
  end

  def get_routing_capacity airline, route_id, routing
    segment_flights = airline.flights.where('route_id IN (?)', routing).select(:user_aircraft_id, :route_id).order(:route_id)
    capacity = {
      :y => 99999,
      :p => 99999,
      :j => 99999,
      :f => 99999
    }
    capacities = {}
    segment_flights.each do |flight|
      route = flight.route_id
      if(!capacities[route])
        capacities[route] = {:y=>0, :p=>0, :j=>0, :f=>0}
      end
      capacities[route] = add_capacity(capacities[route], flight.user_aircraft.aircraft_configuration)
    end
    capacities.each do |route, segment_capacity|
      segment_capacity.each do |cabin, seats|
        capacity[cabin] = [capacity[cabin], seats].min
      end
    end
    capacity
  end

  def add_capacity existing, flight
    existing[:y] += flight.y_count
    existing[:p] += flight.p_count
    existing[:j] += flight.j_count
    existing[:f] += flight.f_count
    existing
  end

  def smallestPlane distance
    mission_capable = Aircraft.where('range >= ?', distance).order(:capacity).limit(1)
    if mission_capable.length == 0
      mission_capable = Aircraft.order(range: :desc).limit(1)
    end
    mission_capable.first
  end

end
