class ShareComputer

  def initialize game_id
    @game_flights = Flight.where("airline_id IN (?)", Airline.where(game_id: game_id).pluck(:id))
    @active_routes = @game_flights.select("DISTINCT route_id").map(&:route_id)
    @airlines = Game.find(game_id).airlines.map(&:id).map{|x| [x, {}]}.to_h # makes hash with key for each airline, value is empty hash
    @airports = Airport.all.map(&:id).map{|x| [x, {destinations: [], airlines: [], flights: 0, passengers: 0}]}.to_h # makes hash with key for each airline, value is empty hash
    parse_routes
    parse_airports
    parse_airport_info game_id
  end

  def parse_routes
    @active_routes.each do |route_id|
      route = Route.select(:distance).find(route_id)
      route_flights = Flight.where("route_id = ? AND airline_id IN (?)", route_id, @airlines.keys)
      airlines = {}
      route_flights.each do |flight|
        aircraft_configuration = flight.user_aircraft.aircraft_configuration
        flight_passengers = flight.passengers
        seats = (flight.frequencies*(aircraft_configuration.f_count + aircraft_configuration.j_count + aircraft_configuration.p_count + aircraft_configuration.y_count))
        passengers = (flight_passengers["f"] + flight_passengers["j"] + flight_passengers["p"] + flight_passengers["y"])
        asm = (seats * route.distance)
        rpm = (passengers * route.distance)
        load_factor = (rpm/asm)
        data  = {
          frequencies: flight.frequencies,
          passengers: passengers,
          seats: seats,
          asm: asm,
          rpm: rpm,
          load_factor: load_factor
        }
        add_flight_to_airport flight, data
        if airlines[flight.airline_id]
          airline = airlines[flight.airline_id]
          airline[:frequencies] += flight.frequencies
          airline[:passengers] += passengers
          airline[:seats] += seats
          airline[:asm] += asm
          airline[:rpm] += rpm
          load_factor = (airline[:rpm]/airline[:asm])
          airline[:load_factor] = load_factor
        else
          airlines[flight.airline_id] = data
        end
      end
      airlines.each do |airline, share|
        existing_market = MarketSize.find_by(marketable_id: route_id, marketable_type: 'Route', airline_id: airline)
        if(existing_market)
          existing_market.update(flights: (share[:frequencies]).round, passengers: (share[:passengers]).round, seats: (share[:seats]).round, asm: (share[:asm]).round, rpm: (share[:rpm]).round, load_factor: share[:load_factor])
        else
          new_market = Route.find(route_id).market_sizes.new(flights: (share[:frequencies]).round, passengers: (share[:passengers]).round, seats: (share[:seats]).round, asm: (share[:asm]).round, rpm: (share[:rpm]).round, load_factor: share[:load_factor], airline_id: airline).save
        end
      end
    end
  end

  def parse_airports
    @airlines.each do |airline, shares|
      shares.each do |airport, share|
        existing_market = MarketSize.find_by(marketable_id: airport, marketable_type: 'Airport', airline_id: airline)
        if(existing_market)
          existing_market.update(flights: (share[:frequencies]).round, passengers: (share[:passengers]).round, seats: (share[:seats]).round, asm: (share[:asm]).round, rpm: (share[:rpm]).round, destinations: share[:destinations].count)
        else
          new_market = Airport.find(airport).market_sizes.new(flights: (share[:frequencies]).round, passengers: (share[:passengers]).round, seats: (share[:seats]).round, asm: (share[:asm]).round, rpm: (share[:rpm]).round, destinations: share[:destinations].count, airline_id: airline).save
        end
      end
    end
  end

  def add_flight_to_airport flight, data
    airports = [flight.route.origin_id, flight.route.destination_id]
    airports.each do |airport|
      @airports[airport][:flights] += data[:frequencies]
      @airports[airport][:passengers] += data[:passengers]
      @airports[airport][:destinations].push flight.route_id
      @airports[airport][:airlines].push flight.airline_id
      if !@airlines[flight.airline_id][airport]
        @airlines[flight.airline_id][airport] = {
          frequencies: 0,
          passengers: 0,
          seats: 0,
          destinations: {},
          asm: 0,
          rpm: 0
        }
      end
      airport_data = @airlines[flight.airline_id][airport]
      airport_data[:frequencies] += data[:frequencies]
      airport_data[:passengers] += data[:passengers]
      airport_data[:seats] += data[:seats]
      airport_data[:destinations][flight.route_id] = 1
      airport_data[:asm] += data[:asm]
      airport_data[:rpm] += data[:rpm]
    end
  end

  def parse_airport_info game_id
    @airports.each do |id,stats|
      existing_market = MarketSize.find_by(marketable_id: id, marketable_type: 'Airport', game_id: game_id)
      if existing_market
        existing_market.update(flights: (stats[:flights]).round, passengers: (stats[:passengers]).round, destinations: stats[:destinations].uniq.count, seats: stats[:airlines].uniq.count)
      else
        Airport.find(id).market_sizes.new(flights: (stats[:flights]).round, passengers: (stats[:passengers]).round, destinations: stats[:destinations].uniq.count, seats: stats[:airlines].uniq.count, game_id: game_id).save
      end
    end
  end

end
