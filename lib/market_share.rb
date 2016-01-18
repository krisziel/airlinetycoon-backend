class ShareComputer

  def init game_id
    @active_routes = Flight.where(game_id).select("DISTINCT route_id").map(&:route_id)
    @airports = Airport.all
  end

  def parse_routes
    @active_routes.each do |route_id|
      route = Route.select(:distance).find(route_id)
      route_flights = Flight.where(route_id: route_id)
      airlines = {}
      route_flights.each do |flight|
        aircraft_configuration = flight.user_aircraft.configuration
        flight_passengers = flight.passengers
        seats = (flight.frequencies*(aircraft_configuration.f_count + aircraft_configuration.j_count + aircraft_configuration.p_count + aircraft_configuration.y_count))
        passengers = (flight_passengers["f"] + flight_passengers["j"] + flight_passengers["p"] + flight_passengers["y"])
        asm = (seats * route.distance)
        rpm = (passengers * route.distance)
        if airlines[id]
          airline = airlines[id]
          airline["frequencies"] += flight.frequencies
          airline["passengers"] += passengers
          airline["seats"] += seats
          airline["asm"] += asm
          airline["rpm"] += rpm
          load_factor = (airline["rpm"]/airline["asm"])
          airline["load_factor"] = load_factor
        else
          load_factor = (rpm/asm)
          airlines[id] = {
            frequencies: flight.frequencies,
            passengers: passengers,
            seats: seats,
            asm: asm,
            rpm: rpm,
            load_factor: load_factor
          }
        end
      end
      airlines.each do |airline|
        existing_market = MarketSize.find_by(route_id: route_id, airline_id: flight.airline_id)
        if(existing_market)
          existing_market.update(frequencies: (frequencies/7).round, passengers: (passengers/7).round, seats: (seats/7).round, asm: (asm/7).round, rpm: (rpm/7).round, load_factor: load_factor)
        else
          Route.find(route_id).market_sizes.new(frequencies: (frequencies/7).round, passengers: (passengers/7).round, seats: (seats/7).round, asm: (asm/7).round, rpm: (rpm/7).round, load_factor: load_factor, airline_id: flight.airline_id)
        end
      end
    end
  end

end
