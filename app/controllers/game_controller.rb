class GameController < ApplicationController
  before_action :airline

  def all
    regions = {
      "all" => "Worldwide",
      "na" => "North America",
      "a" => "Americas",
      "asia" => "Asia",
      "me" => "Middle East",
      "eu" => "Europe",
      "af" => "Africa"
    }
    games = Game.all
    game_list = []
    user = User.find(cookies.signed[:airtycoon_user])
    airlines = user.airlines
    user_games = {}
    user_game_ids = []
    user.airlines.each do |airline|
      user_game_ids.push(airline.game.id)
      user_games[airline.game.id] = airline.name
    end
    games.each do |game|
      if user_game_ids && user_game_ids.include?(game.id)
        player = user_games[game.id]
      else
        player = false
      end
      game = {
        id:game.id,
        region:regions[game.region],
        airlines:game.airlines.length,
        year:game.year,
        name:game.name,
        player:player
      }
      game_list.push(game)
    end
    render json: game_list
  end

  def show
    if cookies.signed[:airtycoon_user]
      game = Game.find(params[:id])
      airlines = []
      game.airlines.each do |airline|
        airline = {
          name:airline.name,
          icao:airline.icao
        }
        airlines.push(airline)
      end
      alliances = []
      game.alliances.each do |alliance|
        alliance = {
          name:alliance.name,
          members:alliance.airlines.length
        }
        alliances.push(alliance)
      end
      if ENV['SECRET_KEY_BASE']
        crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
        cookie = crypt.encrypt_and_sign(game.id)
      end
      game_info = {
        id:game.id,
        region:game.region,
        airlines:airlines,
        alliances:alliances,
        cookie:cookie,
        own:airline.login_info
      }
    else
      game_info = {
        error:"user must log in"
      }
    end
    render json: game_info
  end

  def manual_login
    cookies.signed[:airtycoon_game] = 1
    render json: {
      game_id: cookies.signed[:airtycoon_game]
    }
  end

end
