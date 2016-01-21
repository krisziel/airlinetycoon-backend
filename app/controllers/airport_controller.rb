class AirportController < ApplicationController
  before_action :game, :airline

  def all
    if params[:region]
      region = params[:region] || "all"
      city = "%#{region}%"
      airports = Airport.where("region LIKE ?", region)
    elsif params[:city]
      city = params[:city] || "all"
      city = "%#{city}%"
      airports = Airport.where("citycode LIKE ?", city)
    else
      airports = Airport.where("population > 0")
    end
    airport_list = []
    airports.each do |airport|
      airport_list = airport_list.push(airport.serialize)
    end
    render json: airport_list
  end

  def show
    airport = Airport.find(params[:icao])
    if airport
      airport_data = airport.serialize
    else
      airport_data = {
        error:'#{params[:icao]} not found'
      }
    end
    if game
      airport_data["marketShares"] = airport.market_share_data game.id
    end
    render json: airport_data
  end

end
