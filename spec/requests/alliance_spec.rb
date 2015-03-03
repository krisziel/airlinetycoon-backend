require 'rails_helper'

describe "airtyccon API -- alliance#" do

  it "can create a new alliance" do
    post '/alliance/request',
    {
      name:"Star"
    }
    response = JSON.parse(response.body)
    expect(response["alliance"]["name"]).to eq("Star")
    expect(response["alliance"]["members"].length).to eq(1)
  end

  it 'can request to join an alliance' do
    Airline.create!({
      name: "INnoVation Airlines",
      icao: "INO",
      money: 5000000000,
      game_id: 1,
      user_id: 1
    })
    Alliance.create!({
      name:"Star",
      game_id:1
    })
    post '/alliance/request',
    {
      airline_id:1,
      alliance_id:1
    }
    response = JSON.parse(response.body)
    expect(response["alliance"]["status"]).to eq("requested")
  end

end
