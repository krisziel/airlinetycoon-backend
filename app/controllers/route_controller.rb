class RouteController < ApplicationController
  before_action :airline
  require 'csv'

  def show
    if airline
      if params[:id]
        route = Route.find(params[:id])
        route = route.serialize_flights
      elsif params[:o] && params[:d]
        route = Route.find_by('(origin_id=? AND destination_id=?) OR (origin_id=? AND destination_id=?)',params[:o],params[:d],params[:d],params[:o])
        if route
          route = route.serialize_flights
        else
          route = {
            error: 'no route'
          }
        end
      else
        route = {
          error: 'no route'
        }
      end
    else
      route = {
        error: 'no airline'
      }
    end
    render json: route
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
