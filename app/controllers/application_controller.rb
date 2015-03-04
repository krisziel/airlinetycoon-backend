class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def airline
    if params[:game_id]
      if cookies.signed[:airtycoon_user]
        user = User.find(cookies.signed[:airtycoon_user])
        if user.airlines.where({game_id:params[:game_id]})
          airline = user.airlines.where({game_id:params[:game_id]})[0]
        else
          airline = nil
        end
      end
    else
      airline = nil
    end
    airline
  end

  helper_method :airline

end
