class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  after_filter :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
  # 
  # def self.cors_allowed_actions
  #   @cors_allowed_actions ||= []
  # end
  #
  # def self.cors_allowed_actions=(arr)
  #   @cors_allowed_actions = arr
  # end
  #
  # def self.allow_cors(*methods)
  #   self.cors_allowed_actions += methods
  #   before_filter :cors_before_filter, :only => methods
  #   protect_from_forgery with: :null_session, :only => methods
  # end

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
