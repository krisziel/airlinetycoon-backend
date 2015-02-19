require 'rails_helper'

describe 'user request#' do

  it 'expects to be logged out' do
    post '/user/autologin',
    {
      game_id:1
    }
    login = JSON.parse(response.body)
    expect(login["status"]).to eq('loggedout')
  end

  it 'expects to not have an airline' do
    get '/user/manuallogin'
    post '/user/autologin',
    {
      game_id:1
    }
    login = JSON.parse(response.body)
    expect(login["status"]).to eq('noairline')
  end

  it 'expects to have the user\'s airline returned after autologin' do
    get '/user/manuallogin'
    Airline.create!({
      name: "INnoVation Airlines",
      icao: "INO",
      money: 5000000000,
      game_id: 1,
      user_id: 1
    })
    post '/user/autologin',
    {
      game_id:1
    }
    login = JSON.parse(response.body)
    expect(login["name"]).to eq('INnoVation Airlines')
  end

  it 'can create an user' do
    post '/user/create', {
      user:{
        email: 'kz@kziel.com',
        name: 'Kris',
        username: 'kziel',
        password: 'kziel'
      }
    }
    user = JSON.parse(response.body)
    expect(user["username"]).to eq('kziel')
  end

end
