class UserController < ApplicationController

  def autologin
    user_id = cookies.signed[:airtycoon_user] || 0
    if user_id > 0
      response = {test: user_id}
      user = User.find(user_id)
      airline = Airline.where({user_id: user_id, game_id: params[:game_id].to_i})
      if airline.length > 0
        response = airline[0]
      else
        response = {
          status: "noairline"
        }
      end
    else
      response = {
        status: "loggedout"
      }
    end
    render json: response
  end

  def manuallogin # for rspec
    user = User.new({name:"Kris",username:"kziel",password:"kziel"})
    user.save
    cookies.signed[:airtycoon_user] = 1
    render json: {}
  end

end
