class FlightValidator < ActiveModel::Validator

  def validate(record)
    false
  end

end


class Flight < ActiveRecord::Base
  belongs_to :route
  belongs_to :airline
  belongs_to :user_aircraft
  validates :user_aircraft_id, uniqueness: true

  def serialize
    data = {
      airline: airline_id,
      route: route_id,
      userAircraft: user_aircraft_id,
      duration: duration,
      frequencies: frequencies,
      fare:fare,
      passengers:passengers,
      load:load_average,
      id:id
    }
    data
  end

  def route_serialize
    data = {
      airline: airline.basic_info,
      aircraft: user_aircraft.aircraft.basic_info,
      frequencies: frequencies,
      fare:fare,
      load:load_average,
      id:id
    }
    data
  end

  def full_data
    data = {
      airline:airline.basic_info,
      route:route.serialize,
      userAircraft:user_aircraft.mini_data,
      duration:duration,
      frequencies:frequencies,
      fare:fare,
      passengers:passengers,
      revenue:revenue,
      load:load_average,
      cost:cost,
      profit:profit,
      id:id
    }
    data
  end

  def specific_data
    data = {
      route:route.simple,
      userAircraft:user_aircraft.config,
      duration:duration,
      frequencies:frequencies,
      load:load_average,
      profit:profit,
      id:id
    }
    data
  end

  def mini_data
    flight = {
      route:route.simple,
      userAircraft:user_aircraft.aircraft.full_name,
      frequencies:frequencies,
      id:id
    }
    flight
  end

  def load_average
    if load
      seats = 0
      seats += user_aircraft.aircraft_configuration.f_count
      seats += user_aircraft.aircraft_configuration.j_count
      seats += user_aircraft.aircraft_configuration.p_count
      seats += user_aircraft.aircraft_configuration.y_count
      pax = 0
      if passengers
        pax += passengers['f']
        pax += passengers['j']
        pax += passengers['p']
        pax += passengers['y']
      end
      load['average'] = (((pax*1.0)/(seats*1.0))*100).round
      if load['average'] > 100
        load['average'] = 80+rand(20)
      end
      load
    else
      load
    end
  end

end
