class AirlineController < ApplicationController

  def create
    airplane = {
      name: params[:airline][:name]
    }
    render json: airplane
  end

end
