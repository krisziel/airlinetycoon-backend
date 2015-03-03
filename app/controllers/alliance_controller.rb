class AllianceController < ApplicationController

  def all
    alliances = Alliance.all
    alliance_list = []
    alliances.each do |alliance|
      alliance = {
        name:alliance.name,
        id:alliance.id,
        airlines:alliance.airlines.length
      }
      alliance_list.push(alliance)
    end
    render json: alliance_list
  end

  def create
    user = User.find(cookies.signed[:airtycoon_user])
    alliance = user.airlines.where({game_id:params[:game_id]})[0].alliance
    if alliance
      alliance = {
        name:alliance.name,
        id:alliance.id,
        message:'airline already in alliance'
      }
    else
      alliance = Alliance.new(alliance_params)
      if alliance.save
        alliance = {
          name:alliance.name,
          id:alliance.id,
          message:'alliance created'
        }
      else
        alliance = {
          message:'error creating alliance'
        }
      end
    end
    render json: alliance
  end

  def show
    alliance = Alliance.find(params[:id])
    airlines = []
    alliance.airlines do |airline|
      airline = {
        name:airline.name,
        icao:airline.icao,
        id:airline.id
      }
      airlines.push(airline)
    end
    alliance = {
      name:alliance.name,
      id:alliance.name,
      airlines:airlines
    }
    render json: alliance
  end

  private
  def alliance_params
    params.require(:alliance).permit(:name, :game_id)
  end
  def request_params
    params.require(:alliance).permit(:id, :airline_id)
  end

end
