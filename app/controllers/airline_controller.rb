class AirlineController < ApplicationController

  def all
    airlines = Airline.all
    render json: airlines
  end

  def create
    params[:airline][:money] = 5000000000
    airline = Airline.new(airline_params)
    if airline.save
      render json: airline
    else
      render json: {message:"error creating airline"}
    end
  end

  private
  def airline_params
    params.require(:airline).permit(:name, :icao, :user_id, :game_id, :money)
  end

end
