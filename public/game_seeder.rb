def generator routes, duration
  game = Game.last
  names = ["DAL", "UAL", "AAL", "SIA", "DLH", "SWA", "AAR", "THA", "CSN", "AFR", "QFA", "BAW", "ETD", "UAE", "QTR"]
  airline_hash = []
  names.each do |name|
    user = {
      :name => name,
      :username => name.downcase,
      :password => name.downcase,
      :email => "#{name.downcase}@kziel.com"
    }
    new_user = User.new(user)
    new_user.save
    airline = {
      :name => name,
      :icao => name,
      :money => 1000000000,
      :user_id => new_user.id
    }
    airline_hash.push airline
  end
  b77w = Aircraft.find_by(iata:"CR7").id
  b739 = Aircraft.find_by(iata:"CR2").id
  a359 = Aircraft.find_by(iata:"E70").id
  airline_hash.each do |airline|
    new_airline = game.airlines.new(airline)
    new_airline.save
    new_77w = new_airline.aircraft_configurations.new(name:"777-300ER",aircraft_id:b77w,f_count:rand(4),j_count:rand(6),p_count:rand(18),y_count:rand(30),f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    new_359 = new_airline.aircraft_configurations.new(name:"A350-900",aircraft_id:b739,f_count:0,j_count:rand(4),p_count:rand(12),y_count:rand(16),f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    new_739 = new_airline.aircraft_configurations.new(name:"737-900ER",aircraft_id:b739,f_count:rand(6),j_count:rand(8),p_count:rand(20),y_count:rand(30),f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    new_77w.save
    new_359.save
    new_739.save
    b77w_1 = new_airline.user_aircrafts.new(aircraft_id:b77w, aircraft_configuration_id: new_77w.id, age: 0, inuse: false)
    b77w_2 = new_airline.user_aircrafts.new(aircraft_id:b77w, aircraft_configuration_id: new_77w.id, age: 0, inuse: false)
    a359_1 = new_airline.user_aircrafts.new(aircraft_id:a359, aircraft_configuration_id: new_359.id, age: 0, inuse: false)
    b739_1 = new_airline.user_aircrafts.new(aircraft_id:b739, aircraft_configuration_id: new_739.id, age: 0, inuse: false)
    b77w_1.save
    b77w_2.save
    a359_1.save
    b739_1.save
    new_airline.flights.new(route_id: routes.sample, user_aircraft_id: b77w_1.id, frequencies: rand(14), duration: duration, fare:{f:(406+rand(200)), j:(178+rand(150)), p:(116+rand(100)), y:(55+rand(50))}).save
    new_airline.flights.new(route_id: routes.sample, user_aircraft_id: b77w_2.id, frequencies: rand(14), duration: duration, fare:{f:(406+rand(200)), j:(180+rand(150)), p:(116+rand(100)), y:(55+rand(50))}).save
    new_airline.flights.new(route_id: routes.sample, user_aircraft_id: b739_1.id, frequencies: rand(14), duration: duration, fare:{f:(406+rand(200)), j:(178+rand(150)), p:(116+rand(100)), y:(55+rand(50))}).save
    new_airline.flights.new(route_id: routes.sample, user_aircraft_id: a359_1.id, frequencies: rand(14), duration: duration, fare:{f:(406+rand(200)), j:(178+rand(150)), p:(116+rand(100)), y:(55+rand(50))}).save
  end
end
