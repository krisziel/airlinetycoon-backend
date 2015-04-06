class FlightController < ApplicationController

  before_action :game, :airline

  def all
    if airline
      flights = []
      airline.flights.each do |flight|
        flights.push flight.full_data
      end
      render json: flights
    end
  end

  def aircraft
    if airline
      aircraft = Aircraft.find_by(iata:params[:iata])
      if aircraft
        flight_list = Flight.where(airline_id:airline.id,user_aircraft_id:UserAircraft.where(aircraft_id:aircraft.id))
        flights = []
        flight_list.each do |flight|
          flight = flight.specific_data
          flights.push(flight)
        end
      else
        flights = {error:'aircraft not found'}
      end
    else
      flights = {error:'user not logged in'}
    end
    render json: flights
  end

  def update
    params[:flight][:airline_id] = airline.id
    validate = validate_flight(flight_params,"update", params[:id])
    if validate == true
      flight = Flight.find(params[:id])
      old_aircraft = flight.user_aircraft_id
      p flight
      if flight.update(flight_params)
        UserAircraft.find(old_aircraft).update(inuse:false)
        UserAircraft.find(params[:flight][:user_aircraft_id]).update(inuse:true)
        flight = flight.full_data
      else
        flight = flight.errors.messages
      end
    else
      flight = validate
    end
    render json: flight
  end

  def create
    params[:flight][:airline_id] = airline.id
    validate = validate_flight(flight_params,"create")
    if validate == true
      flight = Flight.new(flight_params)
      if flight.save
        UserAircraft.find(params[:flight][:user_aircraft_id]).update(inuse:true)
        flight = flight.full_data
      else
        flight = flight.errors.message
      end
    else
      flight = validate
    end
    render json: flight
  end

  def delete
    if airline
      flight = Flight.find(params[:id])
      user_aircraft = flight.user_aircraft_id
      if flight.airline == airline
        if flight.destroy
          UserAircraft.find(user_aircraft).update(inuse:false)
          flight = {message:'flight destroyed'}
        else
          flight = {error:'error destroying flight'}
        end
      else
        flight = {error:'flight does not belong to airline'}
      end
    else
      flight = {error:'user not logged in'}
    end
    render json: flight
  end

  def show
    if airline
      flight = Flight.find(params[:id])
      if flight.airline == airline
        flight = flight.full_data
      else
        flight = flight.serialize
      end
    else
      flight = {error:'user not logged in'}
    end
    render json: flight
  end

  private
  def flight_params
    params.require(:flight).permit(:airline_id, :route_id, :user_aircraft_id, :duration, :frequencies, :fare => [:f, :j, :p, :y])
  end

  def validate_flight(flight, status, *id)
    flight[:id] = id[0].to_i if id
    route = Route.find_by(id:flight[:route_id])
    if route
      aircraft_valid = validate_aircraft(flight, route)
      if aircraft_valid[:success]
        fare_valid = validate_fare(flight, route, aircraft_valid[:config])
        if fare_valid == true
          params[:flight][:duration] = aircraft_valid[:duration]
          flight = true
        else
          flight = fare_valid
        end
      else
        flight = aircraft_valid[:errors]
      end
    else
      flight = ['route does not exist']
    end
    flight
  end

  def validate_aircraft(flight, route)
    errors = []
    user_aircraft = UserAircraft.find_by(id:flight[:user_aircraft_id]) # find_by so it doesn't error out if no aircraft is found
    if !user_aircraft
      errors.push('aircraft does not exist')
    else
      if user_aircraft.airline != airline
        errors.push('aircraft does not belong to airline')
      end
      if user_aircraft.flight
        if user_aircraft.inuse && user_aircraft.flight.id != flight[:id]
          errors.push('aircraft is already in use')
        end
      else
        if user_aircraft.flight
          errors.push('aircraft is already in use')
        end
      end
      if route.distance > user_aircraft.aircraft.range
        errors.push('flight is longer than aircraft range')
      end
      flight_duration = (route.distance.to_f/user_aircraft.aircraft.speed.to_f)*60
      rt_time = ((flight_duration+user_aircraft.aircraft.turn_time.to_f)*2)
      max_frequencies = (10080/rt_time).floor
      if flight[:frequencies].to_i > max_frequencies
        errors.push('more frequencies than aircraft can fly')
      end
    end
    errors.length > 0 ? {errors:errors,success:false} : {success:true,duration:flight_duration.to_i,config:user_aircraft.aircraft_configuration}
  end

  def validate_fare(flight, route, config)
    minfare = route.minfare
    maxfare = route.maxfare
    errors = []
    flight[:fare].each do |key,value|
      if value.to_i < minfare[key]
        errors.push("#{key} fare too low")
      elsif value.to_i > maxfare[key]
        errors.push("#{key} fare too high")
      end
    end
    errors.length > 0 ? errors : true
  end

end
