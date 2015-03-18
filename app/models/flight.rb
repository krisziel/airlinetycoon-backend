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
      id:id
    }
    data
  end

  def full_data
    data = {
      airline:airline.basic_info,
      route:route.serialize,
      user_aircraft:user_aircraft.full_data,
      duration:duration,
      frequencies:frequencies,
      fare:fare,
      passengers:passengers,
      revenue:revenue,
      load:load,
      cost:cost,
      profit:profit,
      id:id
    }
  end

end
