require 'rails_helper'

describe "airtyccon API -- alliance#" do

  it "can create a new alliance" do
    get 'user/manuallogin'
    Airline.create!({
      name: "INnoVation Airlines",
      icao: "INO",
      money: 5000000000,
      game_id: 1,
      user_id: 1
    })
    post 'alliances', {
      name:"Star",
      game_id:1
    }
    alliance = JSON.parse(response.body)
    expect(alliance["name"]).to eq("Star")
    expect(alliance["airlines"].length).to eq(1)
  end

  it 'can request to join an alliance' do
    get 'user/manuallogin'
    Airline.create!({name: "INnoVation Airlines",icao: "INO", money: 5000000000,game_id: 1, user_id: 1})
    post 'alliances', {
      name:"Star",
      game_id:1
    }
    post 'user',{
      user:{
        email:"kz@kziel.com",
        name:"Kris",
        username:"kris",
        password:"kris"
      }
    }
    Airline.create!({name: "Maru Airways",icao: "MRU", money: 5000000000,game_id: 1, user_id: 2})
    post 'alliances/1/request', {
      game_id:1
    }
    alliance = JSON.parse(response.body)
    expect(alliance).to eq("requested")
  end

  xit 'returns an error when trying to create an alliance with the same name' do

    expect(alliance["name"]).to eq(["An alliance with that name already exists"])
  end

end

# Airline.create!({name: "INnoVation Airlines",icao: "INO", money: 5000000000,game_id: 1, user_id: 1})
# Airline.create!({name: "Maru Airways",icao: "MRU", money: 5000000000,game_id: 2, user_id: 1})
