class ApplicationController < ActionController::Base
  before_filter :set_access_control_headers, :cookie

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  def cookie
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
    if params[:user_cookie]
      cookies.signed[:airtycoon_user] = crypt.decrypt_and_verify(params[:user_cookie])
    end
    if params[:game_cookie]
      cookies.signed[:airtycoon_game] = crypt.decrypt_and_verify(params[:game_cookie])
    end
    if params[:airline_cookie]
      cookies.signed[:airtycoon_airline] = crypt.decrypt_and_verify(params[:airline_cookie])
    end
  end

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

  helper_method :airline, :game, :cookie

end
