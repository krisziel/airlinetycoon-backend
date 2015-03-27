class AircraftController < ApplicationController
  before_action :airline

  def all
    if airline
      aircrafts = Aircraft.all
      aircraft_list = []
      aircrafts.each do |aircraft|
        user_aircrafts = UserAircraft.where(airline_id:airline.id,aircraft_id:aircraft.id)
        user_aircraft_list = []
        user_aircrafts.each{|ac| user_aircraft_list.push(ac.id) }
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
          sqft:aircraft.sqft,
          user:{inuse:0,unused:0,aircraft:user_aircraft_list}
        }
        aircraft_list.push(this_aircraft)
      end
    else
      aircraft_list = {error:'user not logged in'}
    end
    render json: aircraft_list
  end

  def seats
    seats = Seat.all
    seat_list = []
    seats.each do |seat|
      seat = {
        name:seat.name,
        service_class:seat.service_class,
        rating:seat.rating,
        price:seat.price,
        sqft:seat.sqft
      }
      seat_list.push(seat)
    end
    render json: seat_list
  end

end
