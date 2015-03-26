class AirlineController < ApplicationController
  before_action :airline, :game

  def all
    airlines = Airline.where(game_id:game.id)
    airline_list = []
    airlines.each do |airline|
      if airline.alliance
        alliance = {
          name: airline.alliance.name,
          id: airline.alliance.id
        }
      else
        alliance = nil
      end
      airline = {
        name: airline.name,
        icao: airline.icao,
        alliance: alliance
      }
      airline_list.push(airline)
    end
    render json: airline_list
  end

  def create
    params[:airline][:user_id] = cookies.signed[:airtycoon_user]
    airline = Airline.new(airline_params)
    airline.money = 1000000000
    if airline.save
      if ENV['SECRET_KEY_BASE']
        crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
        cookie = crypt.encrypt_and_sign(params[:airline][:game_id])
      end
      cookies.signed[:airtycoon_game] = params[:airline][:game_id]
      response = {
        name: airline.name,
        icao: airline.icao,
        id: airline.id,
        cookie: cookie
      }
    else
      response = airline.errors.messages
    end
    render json: response
  end

  def show
    if airline
      airline = Airline.find_by(id:params[:id])
      if airline
        response = airline.show_info
      else
        response = {error:'airline not found'}
      end
    else
      response = {error:'user not logged in'}
    end
    render json: response
  end

  private
  def airline_params
    params.require(:airline).permit(:name, :icao, :user_id, :game_id, :money)
  end

end
