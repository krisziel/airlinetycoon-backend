class UserAircraftController < ApplicationController
  before_action :game, :airline

  def all
    aircrafts = airline.user_aircrafts
    aircraft_list = []
    aircrafts.each do |aircraft|
      aircraft_list.push(aircraft.full_data)
    end
    render json: aircraft_list
  end

  def create
    money = airline.money
    aircraft = Aircraft.find(params[:aircraft_id])
    configuration = AircraftConfiguration.find(params[:configuration_id])
    discount = [0.5,(params[:quantity].to_i*(aircraft.discount*0.01))].min
    total_cost = ((1-discount)*params[:quantity].to_i*aircraft.price)
    if configuration.aircraft != aircraft
      response = {
        error:"selected configuration does not aircraft type"
      }
    elsif total_cost > airline.money
      response = {
        error:"user does not have enough money for selected quantity"
      }
    else
      aircraft_list = []
      params[:quantity].to_i.times do |i|
        user_aircraft = UserAircraft.new(aircraft:aircraft, airline:airline, aircraft_configuration:configuration, age:0, inuse:false)
        if user_aircraft.save
          aircraft_list.push(user_aircraft.full_data)
        else
          aircraft_list.push(user_aircraft.errors.messages)
        end
      end
      response = aircraft_list
    end
    render json: response
  end

  def update
    money = airline.money
    user_aircraft = UserAircraft.find(params[:id])
    configuration = AircraftConfiguration.find(params[:configuration_id])
    if configuration.aircraft != user_aircraft.aircraft
      response = {
        error:"selected configuration does not aircraft type"
      }
    else
      if user_aircraft.update(aircraft_configuration:configuration)
        response = user_aircraft.full_data
      else
        response = user_aircraft.errors.messages
      end
    end
    render json: response
  end

  def delete

  end

end
