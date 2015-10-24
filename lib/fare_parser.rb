class FareParser

  def parse_routings id
    fare = Fare.find(id)
    airline = fare.airline
    route = fare.route
    routes_data = []
    routings = fare.routing
    routings.each do |routing|
      duration = (distance/smallestPlane(distance).speed)
      routes_data.push({
        routing: routing,
        price: get_routing_price airline, route.price, duration, routing
      })
    end
  end

  def get_routing_price airline, price, nonstop_duration, routing
    segment_flights = airline.flights.where('route_id IN (?)', routing).select(:duration, :route_id).order(:duration).distinct
    total_duration = segment_flights.inject(0) { |sum, flight| sum + flight.duration }
    discount_rate = (Math.sqrt((total_duration.to_f+((routing.length-1)*60))/nonstop_duration)-1)
    prices = {}
    price.each_with_index do |(key,value),index|
      prices[key] = (price[key]*(1-(discount_rate + (index*0.05))))
    end
  end

  def smallestPlane distance
    return Aircraft.where('range >= ?', distance).order(:capacity).limit(1)
  end

end
