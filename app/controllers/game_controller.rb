class GameController < ApplicationController

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
    games.each do |game|
      game = {
        id:game.id,
        region:regions[game.region],
        airlines:game.airlines.length,
        year:game.year,
        name:game.name
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
      game_info = {
        id:game.id,
        region:game.region,
        airlines:airlines,
        alliances:alliances
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
