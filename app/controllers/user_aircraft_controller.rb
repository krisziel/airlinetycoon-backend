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

  end

  def edit

  end

  def delete

  end

end
