require 'rails_helper'

describe 'airtycoon API -- game#' do
  before do
    get 'user/manuallogin'
    Game.create!(region:"all",year:"2Q2015")
    Game.create!(region:"asia",year:"1Q2010")
    get 'games/manuallogin'
    Airline.create!({name:"INnoVation Airlines", icao:"INO", money:5000000000, game_id:1, user_id:1})
    Airline.create!({name:"Maru Airways", icao:"MRU", money:5000000000, game_id:1, user_id:2})
    Airline.create!({name:"Polt Airlines", icao:"PLT", money:5000000000, game_id:2, user_id:3})
    Alliance.create!({name:"Star Alliance",game_id:1})
  end

  it 'can get a list of all games (the region name is correct)' do
    get 'game'
    games = JSON.parse(response.body)
    expect(games[0]["region"]).to eq('Worldwide')
  end

  it 'can get a list of all games (the number of member airlines is correct)' do
    get 'game'
    games = JSON.parse(response.body)
    expect(games.length).to eq(2)
    expect(games[0]["airlines"]).to eq(2)
  end

  it 'can get details for a game (the list of member airlines has each airline)' do
    get 'game/1'
    game = JSON.parse(response.body)
    expect(game["airlines"][0]["name"]).to eq("INnoVation Airlines")
  end

  it 'can get details for a game (the list of alliances has each alliance)' do
    get 'game/1'
    game = JSON.parse(response.body)
    expect(game["alliances"][0]["name"]).to eq("Star Alliance")
  end

end
