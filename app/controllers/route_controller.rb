class RouteController < ApplicationController

  def all

  end

  def show
    route = Route.find(params[:id])
    render json: route.serialize
  end

  def airport

  end

end
