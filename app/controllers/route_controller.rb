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

end
