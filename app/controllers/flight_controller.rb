class FlightController < ApplicationController

  def all
  end

  def airport
  end

  def aircraft
  end

  def update
  end

  def create
    flight = Flight.new(flight_params)
  end

  def delete
  end

  private
  def flight_params
    params.require(:flight).permit(:airline_id, :route_id, :user_aircraft_id, :duration, :frequencies, :fare)
  end

end
