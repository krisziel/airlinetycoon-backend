class AirportController < ApplicationController

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
      airports = Airport.all
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
      airport = airport.serialize
    else
      airport = {
        error:'#params[:icao] not found'
      }
    end
    render json: airport
  end

end
