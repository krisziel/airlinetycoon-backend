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
      if ENV['SECRET_KEY_BASE']
        crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
        cookie = crypt.encrypt_and_sign(user_id)
      end
      response = {
        id: user.id,
        name: user.name,
        username: user.username,
        cookie:cookie
      }
      cookies.signed[:airtycoon_user] = user.id
    else
      response = user.errors.messages
    end
    render json: response
  end

  def login
    user = User.find_by(username:params[:username])
    if user
      if user.authenticate(params[:password])
        if ENV['SECRET_KEY_BASE']
          crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
          cookie = crypt.encrypt_and_sign(user.id)
        end
        response = {loggedin:'true',cookie:cookie}
      else
        response = {error:'invalid password'}
      end
    else
      response = {error:'user not found'}
    end
    render json: response
  end

  def manuallogin # for rspec
    cookies.signed[:airtycoon_user] = {
      value:2,
      expires: 1.year.from_now
    }
    if !params[:clean]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    end
    user = User.new({name:"Kris",username:"kziel",password:"kziel",email:"krisziel@mac.com"})
    if user.save
      cookies.signed[:airtycoon_user] = user.id
      render json: {user_id:user.id}
    else
      cookies.signed[:airtycoon_user] = 2
      render json: user.errors.messages
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :username, :password)
  end

end
