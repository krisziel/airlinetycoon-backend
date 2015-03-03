require 'rails_helper'

describe "airtyccon API -- alliance#" do

  it "can create a new alliance" do
    get 'user/manuallogin'
    post 'alliances',
    {
      name:"Star"
    }
    alliance = JSON.parse(response.body)
    expect(alliance["name"]).to eq("Star")
    expect(alliance["airlines"].length).to eq(1)
  end

  xit 'can request to join an alliance' do
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
    post '/alliance/request',
    {
      airline_id:1,
      alliance_id:1
    }
    response = JSON.parse(response.body)
    expect(response["alliance"]["status"]).to eq("requested")
  end

end

# Airline.create!({name: "INnoVation Airlines",icao: "INO", money: 5000000000,game_id: 1, user_id: 1})
# Airline.create!({name: "Maru Airways",icao: "MRU", money: 5000000000,game_id: 2, user_id: 1})
