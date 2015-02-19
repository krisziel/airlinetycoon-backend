class AircraftsController < ApplicationController

  def index
    render json: [{
      name: "777"
    }]
  end

end
