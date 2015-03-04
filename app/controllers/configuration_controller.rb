class ConfigurationController < ApplicationController
  before_action :airline

  def all
    configurations = AircraftConfiguration.where(:airline_id => airline.id)
    configuration_list = []
    configurations.each do |configuration|
      configuration_list.push(config_serializer(configuration))
    end
    render json: configuration_list
  end

  def type
    aircraft_id = Aircraft.find_by(iata:params[:type])
    configurations = AircraftConfiguration.where(airline_id:airline.id,aircraft_id:aircraft_id)
    configuration_list = []
    configurations.each do |configuration|
      configuration_list.push(config_serializer(configuration))
    end
    render json: configuration_list
  end

  def create
    seats = JSON.parse(params[:config][:seats])
    config = params[:config]
    config[:f_count] = seats["f"]["count"]
    config[:j_count] = seats["j"]["count"]
    config[:p_count] = seats["p"]["count"]
    config[:y_count] = seats["y"]["count"]
    config[:f_seat] = seats["f"]["id"]
    config[:j_seat] = seats["j"]["id"]
    config[:p_seat] = seats["p"]["id"]
    config[:y_seat] = seats["y"]["id"]
    configuration = AircraftConfiguration.new(config_params)
    if configuration.save
      config_response = configuration
    else
      config_response = configuration.errors.message
    end
    render json: config_response
  end

  private
  def config_params
    params.require(:config).permit(:name, :airline_id, :aircraft_id, :f_count, :j_count, :p_count, :y_count, :f_seat, :j_seat, :p_seat, :y_seat)
  end

  def config_serializer configuration
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
        full_name:configuration.aircraft.full_name,
        iata:configuration.aircraft.iata
      },
      seats:{
        f:f_seat || nil,
        j:j_seat || nil,
        p:p_seat || nil,
        y:y_seat || nil
      }
    }
    configuration
  end

end
