class ConfigurationController < ApplicationController
  before_action :airline

  def all
    configurations = AircraftConfiguration.where(:airline_id => airline.id)
    configuration_list = []
    configurations.each do |configuration|
      configuration.f_seat ? f_seat = Seat.find(configuration.f_seat) : f_seat = nil
      configuration.j_seat ? j_seat = Seat.find(configuration.j_seat) : j_seat = nil
      configuration.p_seat ? p_seat = Seat.find(configuration.p_seat) : p_seat = nil
      configuration.y_seat ? y_seat = Seat.find(configuration.y_seat) : y_seat = nil
      if f_seat
        f_seat = {
          count:configuration.f_count,
          name:f_seat.name,
          rating:f_seat.rating,
          price:f_seat.price
        }
      end
      if j_seat
        j_seat = {
          count:configuration.j_count,
          name:j_seat.name,
          rating:j_seat.rating,
          price:j_seat.price
        }
      end
      if p_seat
        p_seat = {
          count:configuration.p_count,
          name:p_seat.name,
          rating:p_seat.rating,
          price:p_seat.price
        }
      end
      if y_seat
        y_seat = {
          count:configuration.y_count,
          name:y_seat.name,
          rating:y_seat.rating,
          price:y_seat.price
        }
      end
      configuration = {
        id:configuration.id,
        name:configuration.name,
        aircraft:{
          id:configuration.aircraft.id,
          name:configuration.aircraft.name,
          manufacturer:configuration.aircraft.manufacturer,
          full_name:configuration.aircraft.full_name
        },
        seats:{
          f:f_seat || nil,
          j:j_seat || nil,
          p:p_seat || nil,
          y:y_seat || nil
        }
      }
      configuration_list.push(configuration)
    end
    render json: configuration_list
  end

end
