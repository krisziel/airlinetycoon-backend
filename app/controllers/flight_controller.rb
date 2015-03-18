class FlightController < ApplicationController

  before_action :game, :airline

  def all
  end

  def airport
  end

  def aircraft
  end

  def update
  end

  def create
    validate_flight(flight_params)
    flight = Flight.new(flight_params)
  end

  def delete
  end

  private
  def flight_params
    params.require(:flight).permit(:airline_id, :route_id, :user_aircraft_id, :duration, :frequencies, :fare)
  end

  def validate_flight(flight)
    validate_aircraft(flight)
  end

  def validate_aircraft(flight)
    errors = []
    user_aircraft = UserAircraft.find(flight[:user_aircraft_id])
    route = Route.find(route_id)
    if !user_aircraft
      errors.push('Aircraft does not exist')
    else
      if user_aircraft.airline != airline
        errors.push('Aircraft does not belong to airline')
      end
      if flight.id
        if user_aircraft.inuse && user_aircraft.flight_id != flight.id
          errors.push('Aircraft is already in use')
        end
      else
        if user_aircraft.inuse
          errors.push('Aircraft is already in use')
        end
      end
      if route.distance > user_aircraft.aircraft.range
        errors.push('Flight is longer than aircraft range')
      end
      flight_time = (((route.distance.to_f/user_aircraft.aircraft.speed.to_f)*60+user_aircraft.aircraft.turn_time.to_f)*2)
      max_frequencies = (10080/flight_time).floor
      if frequencies > max_frequencies
        errors.push('More frequencies than aircraft can fly')
      end
    end
  end

end

# t.integer  "airline_id"
# t.integer  "route_id"
# t.integer  "user_aircraft_id"
# t.integer  "duration"
# t.integer  "frequencies"
# t.json     "fare"
