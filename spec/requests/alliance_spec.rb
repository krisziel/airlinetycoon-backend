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
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
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
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    post 'alliances/1/request', {
      game_id:1
    }
    alliance = JSON.parse(response.body)
    expect(alliance["message"]).to eq("membership requested")
  end

  it 'returns an error if the airline is already in an alliance' do
    get 'user/manuallogin'
    airline = Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    alliance = Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1})
    alliance = Alliance.create!({name:"SK Telecom", game_id:1})
    post 'alliances/2/request',
    {
      game_id:1
    }
    req = JSON.parse(response.body)
    expect(req["message"]).to eq("airline pending acceptance into alliance")
  end

  it 'returns an error when trying to create an alliance with the same name' do
    get 'user/manuallogin'
    Airline.create!({name: "INnoVation Airlines",icao: "INO", money: 5000000000,game_id: 1, user_id: 1})
    Alliance.create!({name: "Star Alliance", game_id: 1})
    AllianceMembership.create!({airline_id:1,alliance_id:1})
    post 'user',{
      user:{
        email:"kz@kziel.com",
        name:"Kris",
        username:"kris",
        password:"kris"
      }
    }
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    post 'alliances', {
      name:"Star Alliance",
      game_id:1
    }
    alliance = JSON.parse(response.body)
    expect(alliance["name"]).to eq(["An alliance with that name already exists"])
  end

  it 'allows admin to approve airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:1})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:false, position:2})
    post 'alliances/1/approve',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["airline"]["name"]).to eq('Maru Airways')
    expect(membership["status"]).to eq(true)
  end

  it 'prevents non-admin from approving airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:2})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:false, position:2})
    post 'alliances/1/approve',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["error"]).to eq('Airline does not have permission')
  end

  it 'allows admin to reject airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:1})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:false, position:2})
    post 'alliances/1/reject',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["airline"]["name"]).to eq('Maru Airways')
    expect(membership["status"]).to eq(false)
  end

  it 'prevents non-admin from rejecting airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:2})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:false, position:2})
    post 'alliances/1/reject',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["error"]).to eq('Airline does not have permission')
  end

  it 'allows admin to eject airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:1})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:true, position:2})
    post 'alliances/1/eject',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["airline"]["name"]).to eq('Maru Airways')
    expect(membership["status"]).to eq(false)
  end

  it 'prevents non-admin from ejecting airlines' do
    get 'user/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Alliance.create!({name:"Star Alliance", game_id:1})
    AllianceMembership.create!({airline_id:1, alliance_id:1, status:true, position:2})
    AllianceMembership.create!({airline_id:2, alliance_id:1, status:true, position:2})
    post 'alliances/1/eject',
    {
      membership_id:2
    }
    membership = JSON.parse(response.body)
    expect(membership["error"]).to eq('Airline does not have permission')
  end

end
