class AircraftController < ApplicationController

  def all
    aircrafts = Aircraft.all
    aircraft_list = []
    aircrafts.each do |aircraft|
      this_aircraft = {
        manufacturer:aircraft.manufacturer,
        name:aircraft.name,
        full_name:aircraft.full_name,
        iata:aircraft.iata,
        capacity:aircraft.capacity,
        speed:aircraft.speed,
        turn_time:aircraft.turn_time,
        price:aircraft.price,
        discount:aircraft.discount,
        range:aircraft.range,
        sqft:aircraft.sqft
      }
      aircraft_list.push(this_aircraft)
    end
    render json: aircraft_list
  end

end
