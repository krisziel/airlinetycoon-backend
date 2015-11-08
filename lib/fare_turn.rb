class FareTurn

  def initialize
    @elasticity = {
      [1.25,100.0] => {
        base:0.4509,
        margin:1.009,
        anchor:1.25
      },
      [1.0,1.25] => {
        base:0.0,
        margin:1.015,
        anchor:1.0
      },
      [1.0,1.0] => {
        base:0.0,
        margin:1,
        anchor:1.0
      },
      [0.9,1.0] => {
        base:0.0,
        margin:0.994,
        anchor:1.0
      },
      [0.7,0.9] => {
        base:-0.0584,
        margin:0.975,
        anchor:0.9
      },
      [-100.0,0.7] => {
        base:-0.4325,
        margin:0.95,
        anchor:0.7
      }
    }
  end
  @routes = {}
  @fares = {}

  def game_fares game_id
    start = Time.now.to_f
    fares = Fare.where(airline_id:Airline.where(game_id:game_id)).order('route_id DESC') # get every fare belonging to every airline in the game
    total_fares = fares.length # just for logging
    organized_routes = organize_fares(fares) # organize fares by route id
    @routes = organized_routes # instance variable
    organized_routes.each do |route, routings| # for each route
      flights = compare_demand(sort_fares(routings)) # go through the demand for the route and determine passenger distribution
      prep_for_update(flights) # prepare data to update database
    end
    puts "Determined passengers for #{total_fares} flights on #{organized_routes.length} routes took #{Time.now.to_f - start} seconds"
  end

  def organize_fares fares # put every fare into an array where the key is the route id
    routes = {} # empty hash
    fares.each do |fare| # for every single fare within the game
      if routes[fare.route_id] # if there is already an array within the hash for this route id
        routes[fare.route_id] = routes[fare.route_id] + fare.fare_routings # add all the fare routings for the fare to the array
      else
        routes[fare.route_id] = fare.fare_routings # or create a new array with all the fare routings with the route id as the key
      end
    end
    routes
  end

  def sort_flight_reformat fare
    reformatted = { f:{}, j:{}, p:{}, y:{} }
    fare[:cabins].each do |key,cabin|
      reformatted[key] = {
        :id => fare[:id],
        :fare => cabin[:fare],
        :multiplier => cabin[:pricing][:multiplier],
        :count => cabin[:count],
        :occupied => 0
      }
    end
    reformatted
  end

  def compare_demand route
    route[:fares].each do |key, cabin|
      total_pax = route[:market][:cabins][key.to_sym][:demand]
      remaining_pax = total_pax
      placed_pax = 0
      airlines = airlines_with_cabin(cabin)
      airlines.each_with_index do |fare, index|
        pax_at_fare = fare[:multiplier]*total_pax.round
        pax_at_fare = (pax_at_fare - placed_pax)
        airlines[index..-1].each_with_index do |airline, i|
          pax_per_airline = pax_at_fare/(airlines.length-index-i)
          open_seats = (airline[:count] - airline[:occupied])
          if pax_per_airline > open_seats
            pax_at_fare = pax_at_fare - open_seats
            pax_on_airline = open_seats
          else
            pax_on_airline = pax_per_airline
            pax_at_fare = (pax_at_fare - pax_on_airline)
          end
          pax_on_airline = 0 if pax_on_airline < 0
          placed_pax += pax_on_airline
          remaining_pax -= pax_on_airline
          airline[:occupied] += pax_on_airline
        end
        airlines[index][:occupied] = airlines[index][:occupied].round
      end
    end
    route
  end

  def sort_fares routings
    market = routings[0].fare.route.demand
    sorted_fares = { :f=>[], :j=>[], :p=>[], :y=>[] }
    routings.each do |routing|
      reformat = format_routing_demand routing
      sorted_fares[:f].push(reformat[:f])
      sorted_fares[:j].push(reformat[:j])
      sorted_fares[:p].push(reformat[:p])
      sorted_fares[:y].push(reformat[:y])
    end
    sorted_fares[:f].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:j].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:p].sort_by!{|value| value[:fare] }.reverse!
    sorted_fares[:y].sort_by!{|value| value[:fare] }.reverse!
    data = { :market => market, :fares => sorted_fares }
    data
  end

  def format_routing_demand routing
    id = routing.id
    route_info = { :f=>{
        :fare => routing.fare.fare["f"],
        :market => determine_market_demand(routing.market_fare["f"], routing.fare.fare["f"]),
        :id => id
      }, :j=>{
        :fare => routing.fare.fare["j"],
        :market => determine_market_demand(routing.market_fare["j"], routing.fare.fare["j"]),
        :id => id
      }, :p=>{
        :fare => routing.fare.fare["p"],
        :market => determine_market_demand(routing.market_fare["p"], routing.fare.fare["p"]),
        :id => id
      }, :y=>{
        :fare => routing.fare.fare["y"],
        :market => determine_market_demand(routing.market_fare["y"], routing.fare.fare["y"]),
        :id => id
      }
    }
    route_info
  end

  def determine_market_demand market, fare
    demand = { :spread=>1.0, :elasticity=>{}, :percent=>0, :multiplier=>0 }
    if (market && fare) && (market > 0) # no point in trying computations if both don't exist or required market fare is subzero
      market = market.to_f
      fare = fare.to_f
      spread = (market-fare)/market
      demand[:spread] = spread.round(4)
      demand[:percent] = (demand[:spread].abs*100).round
      @elasticity.each do |key,value|
        if (1.0+demand[:spread]).between?(key[0],key[1]) # if the difference between the market/fare is within the range of this elasticity range
          demand[:elasticity] = value
        end
      end
      multiplier = compute_multiplier(demand)
      if multiplier < 0.25 # if the multiplier is below .25, probably not worth giving the routing any passengers
        demand[:multiplier] = multiplier
      end
    end
    demand
  end

  def compute_multiplier demand
    exponent = ((1.0+demand[:spread])-demand[:elasticity][:anchor])
    exponent = (exponent*100).abs.floor.to_i
    multiplier = (demand[:elasticity][:margin]**exponent)+demand[:elasticity][:base]
    multiplier = multiplier.round(4)
  end

  # def reformat_routing


















  # def organize_flights flights
  #   routes = {}
  #   flight_routes = {}
  #   flights.each do |flight|
  #     if routes[flight.route_id]
  #       flight_routes[flight.route_id].push(flight)
  #     else
  #       route = flight.route
  #       routes[flight.route_id] = route
  #       flight_routes[flight.route_id] = [flight]
  #     end
  #   end
  #   @routes = flight_routes
  #   reformatted_routes = []
  #   routes.each do |id,route|
  #     route = {
  #       :route => reformat_route(route)
  #     }
  #     flights = process_route({
  #       :flights => flight_routes[id],
  #       :market => route[:route][:cabins]
  #     })
  #     route[:flights] = flights
  #     reformatted_routes.push(route)
  #   end
  #   reformatted_routes
  # end
  #
  # def process_route route
  #   flights = []
  #   route[:flights].each do |flight|
  #     flight = reformat_flight(flight,route[:market])
  #     flights.push(flight)
  #   end
  #   flights
  # end
  #
  # def reformat_route route
  #   price = route.price
  #   demand = route.demand
  #   route = {
  #     :id => route.id,
  #     :cabins => {
  #       :f => {
  #         :fare => price["f"],
  #         :demand => demand["f"]
  #       },
  #       :j => {
  #         :fare => price["j"],
  #         :demand => demand["j"]
  #       },
  #       :p => {
  #         :fare => price["p"],
  #         :demand => demand["p"]
  #       },
  #       :y => {
  #         :fare => price["y"],
  #         :demand => demand["y"]
  #       }
  #     }
  #   }
  #   route
  # end
  #
  # def reformat_flight flight, market
  #   configuration = flight.user_aircraft.aircraft_configuration
  #   layout = configuration.config_details[:config]
  #   fares = flight.fare
  #   flight = {
  #     :id => flight.id,
  #     :cabins => {
  #       :f => {
  #         :fare => fares["f"].to_i,
  #         :count => ((layout[:f][:count]*flight.frequencies)/7).round,
  #         :pricing => price_spread(market[:f][:fare],fares["f"])
  #       },
  #       :j => {
  #         :fare => fares["j"].to_i,
  #         :count => ((layout[:j][:count]*flight.frequencies)/7).round,
  #         :pricing => price_spread(market[:j][:fare],fares["j"])
  #       },
  #       :p => {
  #         :fare => fares["p"].to_i,
  #         :count => ((layout[:p][:count]*flight.frequencies)/7).round,
  #         :pricing => price_spread(market[:p][:fare],fares["p"])
  #       },
  #       :y => {
  #         :fare => fares["y"].to_i,
  #         :count => ((layout[:y][:count]*flight.frequencies)/7).round,
  #         :pricing => price_spread(market[:y][:fare],fares["y"])
  #       }
  #     }
  #   }
  #   flight
  # end
  #
  # def price_spread market, fare
  #   demand = {
  #     :spread => 1.0,
  #     :elasticity => {},
  #     :percent => 0,
  #     :multiplier => 1
  #   }
  #   if market && fare
  #     market = market.to_f
  #     fare = fare.to_f
  #     spread = (market-fare)/market
  #     demand[:spread] = spread.round(4)
  #     demand[:percent] = (demand[:spread].abs*100).round
  #     @elasticity.each do |key,value|
  #       if (1.0+demand[:spread]).between?(key[0],key[1])
  #         demand[:elasticity] = value
  #       end
  #     end
  #     demand[:multiplier] = compute_multiplier(demand)
  #   end
  #   demand
  # end
  #
  # def compute_multiplier demand
  #   exponent = ((1.0+demand[:spread])-demand[:elasticity][:anchor])
  #   exponent = (exponent*100).abs.floor.to_i
  #   multiplier = (demand[:elasticity][:margin]**exponent)+demand[:elasticity][:base]
  #   multiplier = multiplier.round(4)
  # end
  #
  # def sort_fares route
  #   puts route.inspect
  #   sorted_fares = {
  #     :f => [],
  #     :j => [],
  #     :p => [],
  #     :y => []
  #   }
  #   route[:flights].each do |flight|
  #     reformat = reform_sort_flight flight
  #     sorted_fares[:f].push(reformat[:f])
  #     sorted_fares[:j].push(reformat[:j])
  #     sorted_fares[:p].push(reformat[:p])
  #     sorted_fares[:y].push(reformat[:y])
  #   end
  #   sorted_fares[:f].sort_by!{|value| value[:fare] }.reverse!
  #   sorted_fares[:j].sort_by!{|value| value[:fare] }.reverse!
  #   sorted_fares[:p].sort_by!{|value| value[:fare] }.reverse!
  #   sorted_fares[:y].sort_by!{|value| value[:fare] }.reverse!
  #   { :market => route[:route], :fares => sorted_fares }
  # end
  #
  # def reform_sort_flight flight
  #   reformat = {
  #     f:{},
  #     j:{},
  #     p:{},
  #     y:{}
  #   }
  #   flight[:cabins].each do |key,cabin|
  #     reformat[key] = {
  #       :id => flight[:id],
  #       :fare => cabin[:fare],
  #       :multiplier => cabin[:pricing][:multiplier],
  #       :count => cabin[:count],
  #       :occupied => 0
  #     }
  #   end
  #   reformat
  # end
  #
  # def compare_demand route
  #   route[:fares].each do |key, cabin|
  #     total_pax = route[:market][:cabins][key.to_sym][:demand]
  #     remaining_pax = total_pax
  #     placed_pax = 0
  #     airlines = airlines_with_cabin(cabin)
  #     airlines.each_with_index do |fare, index|
  #       pax_at_fare = fare[:multiplier]*total_pax.round
  #       pax_at_fare = (pax_at_fare - placed_pax)
  #       airlines[index..-1].each_with_index do |airline, i|
  #         pax_per_airline = pax_at_fare/(airlines.length-index-i)
  #         open_seats = (airline[:count] - airline[:occupied])
  #         if pax_per_airline > open_seats
  #           pax_at_fare = pax_at_fare - open_seats
  #           pax_on_airline = open_seats
  #         else
  #           pax_on_airline = pax_per_airline
  #           pax_at_fare = (pax_at_fare - pax_on_airline)
  #         end
  #         pax_on_airline = 0 if pax_on_airline < 0
  #         placed_pax += pax_on_airline
  #         remaining_pax -= pax_on_airline
  #         airline[:occupied] += pax_on_airline
  #       end
  #       airlines[index][:occupied] = airlines[index][:occupied].round
  #     end
  #   end
  #   route
  # end
  #
  # def airlines_with_cabin airlines
  #   airline_list = []
  #   airlines.each do |cabin|
  #     if cabin[:count] > 0
  #       airline_list.push(cabin)
  #     end
  #   end
  #   airline_list
  # end
  #
  # def update_flight id, flight_data
  #   flight = Flight.find(id)
  #   cost = compute_cost flight.user_aircraft.aircraft, flight.route, flight.duration, flight.frequencies, flight.user_aircraft.aircraft_configuration
  #   flight_data[:profit] = (flight_data[:total_revenue] - cost)
  #   airline_money = flight.airline.money + flight_data[:profit]*(52/12)
  #   flight.airline.update(money:airline_money)
  #   flight_data.delete(:total_revenue)
  #   flight.update(flight_data)
  # end
  #
  # def prep_for_update route
  #   flights = {}
  #   route[:fares].each do |cabin,flight_list|
  #     flight_list.each do |flight|
  #       id = flight[:id]
  #       if !flights[id]
  #         flights[id] = {}
  #       end
  #       flights[id][cabin.to_sym] = flight
  #     end
  #   end
  #   flights.each do |id,flight|
  #     format_for_update(id,flight)
  #   end
  # end
  #
  # def format_for_update id, flight
  #   flight_data = {
  #     :passengers => {},
  #     :load => {},
  #     :revenue => {},
  #     :total_revenue => 0
  #   }
  #   flight.each do |cabin, data|
  #     if data[:count] > 0
  #       load = ((data[:occupied].to_f/data[:count].to_f)*100).round
  #     else
  #       load = 0
  #     end
  #     revenue = (data[:occupied]*7*data[:fare])
  #     flight_data[:passengers][cabin.to_sym] = data[:occupied]*7
  #     flight_data[:load][cabin.to_sym] = load
  #     flight_data[:revenue][cabin.to_sym] = revenue
  #     flight_data[:total_revenue] += revenue
  #   end
  #   update_flight id, flight_data
  # end
  #
  # def compute_cost aircraft, route, duration, freq, config
  #   gpm = (aircraft.fuel_capacity.to_f/aircraft.range.to_f)
  #   fuel_cost = (gpm*route.distance*2*2.25*freq)
  #   fa_cost = (((config[:y_count]/50).ceil+(config[:p_count]/24).ceil+(config[:j_count]/8).ceil+(config[:f_count]/4).ceil)*(1+((duration-240).abs/240).ceil))*freq*duration*2
  #   service_cost = ((config[:y_count]*3)+(config[:p_count]*5)+(config[:j_count]*15)+(config[:f_count]*30))
  #   pilot_cost = (duration*freq*(1+((duration-240).abs/240).ceil)*2.5)
  #   total_cost = (fuel_cost+(fa_cost*2)+(pilot_cost)+(fuel_cost/3))
  #   total_cost
  # end

end
