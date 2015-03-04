class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def airline
    if cookies.signed[:airtycoon_game]
      if cookies.signed[:airtycoon_user]
        user = User.find(cookies.signed[:airtycoon_user])
        airline = user.airlines.find_by(game_id:cookies.signed[:airtycoon_game])
      end
    else
      airline = nil
    end
    airline
  end

  def game
    if cookies.signed[:airtycoon_game]
      game = Game.find(cookies.signed[:airtycoon_game])
    else
      game = nil
    end
    game
  end

  helper_method :airline, :game

end
