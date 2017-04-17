class ApplicationController < ActionController::Base
  before_filter :set_access_control_headers, :cookie

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  def cookie
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
    airline = request.headers['X-AIRLINE-KEY']
    username = request.headers['X-USERNAME-KEY']
    game = request.headers['X-GAME-KEY']
    if username
      @@username = crypt.decrypt_and_verify(username)
    end
    if game
      @@game = crypt.decrypt_and_verify(game)
    end
    if airline
      @@airline = crypt.decrypt_and_verify(airline)
    end
  end

  def airline
    if @@game
      if @@username
        user = User.find(@@username)
        airline = user.airlines.find_by(game_id:@@game)
      end
    else
      airline = nil
    end
    airline
  end

  def game
    if @@game
      game = Game.find(@@game)
    else
      game = nil
    end
    game
  end

  def user
    if @@username
      user = User.find(@@username)
    else
      user = nil
    end
    user
  end

  helper_method :airline, :game, :cookie, :user

end
