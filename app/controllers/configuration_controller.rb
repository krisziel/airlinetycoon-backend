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
    seats = params[:config][:seats]
    params[:config][:airline_id] = airline.id
    config = params[:config]
    config[:f_count] = seats["count"]["f"]
    config[:j_count] = seats["count"]["j"]
    config[:p_count] = seats["count"]["p"]
    config[:y_count] = seats["count"]["y"]
    config[:f_seat] = seats["id"]["f"]
    config[:j_seat] = seats["id"]["j"]
    config[:p_seat] = seats["id"]["p"]
    config[:y_seat] = seats["id"]["y"]
    configuration = AircraftConfiguration.new(config_params)
    valid_config = validate_configuration configuration
    config[:f_count] = valid_config[:f][:count]
    config[:j_count] = valid_config[:j][:count]
    config[:p_count] = valid_config[:p][:count]
    config[:y_count] = valid_config[:y][:count]
    configuration = AircraftConfiguration.new(config_params)
    if configuration.save
      config_response = configuration.config_details
    else
      config_response = configuration.errors.messages
    end
    render json: config_response
  end

  def delete
    config = AircraftConfiguration.find_by(id:params[:id],airline_id:airline.id)
    aircrafts = config.user_aircraft
    if aircrafts.length == 0
      config.destroy
      response = {
        message:"configuration deleted"
      }
    else
      aircraft_list = []
      aircrafts.each do |aircraft|
        aircraft_list.push(aircraft.full_data)
      end
      response = {
        message:"aircraft configuration in use",
        aircraft:aircraft_list
      }
    end
    render json: response
  end

  private
  def config_params
    params.require(:config).permit(:name, :airline_id, :aircraft_id, :f_count, :j_count, :p_count, :y_count, :f_seat, :j_seat, :p_seat, :y_seat)
  end

  def validate_configuration configuration
    config = configuration
    aircraft = configuration.aircraft
    sqft = aircraft.sqft.to_f
    f_data = validate_space(sqft,{ id:config[:f_seat], count:config[:f_count] })
    sqft -= f_data[:sqft]
    j_data = validate_space(sqft,{ id:config[:j_seat], count:config[:j_count] })
    sqft -= j_data[:sqft]
    p_data = validate_space(sqft,{ id:config[:p_seat], count:config[:p_count] })
    sqft -= p_data[:sqft]
    y_data = validate_space(sqft,{ id:config[:y_seat], count:config[:y_count] })
    sqft -= y_data[:sqft]
    all_data = {
      f:f_data,
      j:j_data,
      p:p_data,
      y:y_data
    }
    all_data
  end

  def validate_space sqft, seat
    seat[:id] > 0 ? seat_sqft = Seat.find(seat[:id]).sqft : seat_sqft = 0
    cabin_sqft = seat_sqft.to_f * seat[:count].to_f
    response = {}
    if cabin_sqft > sqft
      available = (sqft/seat_sqft).floor
      cabin_sqft = (available * seat_sqft)
      seat[:count] = available
    end
    seat[:sqft] = cabin_sqft
    seat
  end

  def config_serializer configuration
    configuration.f_seat > 0 ? f_seat = Seat.find(configuration.f_seat) : f_seat = nil
    configuration.j_seat > 0 ? j_seat = Seat.find(configuration.j_seat) : j_seat = nil
    configuration.p_seat > 0 ? p_seat = Seat.find(configuration.p_seat) : p_seat = nil
    configuration.y_seat > 0 ? y_seat = Seat.find(configuration.y_seat) : y_seat = nil
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
      aircraft:configuration.aircraft.basic_info,
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
