require 'rails_helper'

describe 'airtycoon API -- game#' do
  before do
    Game.create!(region:"all",year:"2Q2015")
    Game.create!(region:"asia",year:"1Q2010")
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Airline.create!({name:"Polt Airlines", icao:"PLT", money:5000000000, game_id:2, user_id:3})
    Alliance.create!({name:"Star Alliance",game_id:1})
    get 'user/manuallogin'
  end

  it 'can get a list of all games' do
    get 'games'
    games = JSON.parse(response.body)
    expect(games.length).to eq(2)
    expect(games[0]["region"]).to eq('all')
    expect(games[0]["airlines"]).to eq(2)
  end

  it 'can get details for a game' do
    get 'games/1'
    game = JSON.parse(response.body)
    expect(game["airlines"][0]["name"]).to eq("INnoVation Airlines")
    expect(game["alliances"][0]["name"]).to eq("Star Alliance")
  end

end
