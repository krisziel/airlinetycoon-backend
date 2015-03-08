class UserController < ApplicationController

  def autologin
    user_id = cookies.signed[:airtycoon_user] || 0
    if user_id > 0
      user = User.find(user_id)
      airline = Airline.where({user_id: user_id, game_id: cookies.signed[:airtycoon_game]})
      if airline.length > 0
        airline = airline[0]
        if airline.alliance
          alliance = {
            name: airline.alliance.name,
            id: airline.alliance.id
          }
        else
          alliance = nil
        end
        response = {
          username: user.username,
          id: user.id,
          name: user.name,
          airline:{
            money: airline.money,
            name: airline.name,
            icao: airline.icao,
            alliance: alliance
          }
        }
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

  def create
    user = User.new(user_params)
    if user.save
      response = {
        id: user.id,
        name: user.name,
        username: user.username
      }
      cookies.signed[:airtycoon_user] = user.id
    else
      response = user.errors.message
    end
    render json: response
  end

  def manuallogin # for rspec
    if !params[:clean]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    end
    user = User.new({name:"Kris",username:"kziel",password:"kziel",email:"krisziel@mac.com"})
    if user.save
      cookies.signed[:airtycoon_user] = 1
      render json: {user_id:user.id}
    else
      render json: user.errors.messages
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :username, :password)
  end

end
