class RouteController < ApplicationController

  before_action :airline

  def show
    if airline
      route = Route.find(params[:id])
      render json: route.serialize
    else
      render json: {
        error: 'no airline'
      }
    end
  end

  def airport
    if airline
      airport = Airport.find_by(iata:params[:iata])
      if airport
        routes = Route.where("origin=? OR destination=?",airport,airport)
      else
        routes = {error:'airport does not exist'}
      end
    else
      routes = {error:'user not logged in'}
    end
    render json: routes
  end

end
