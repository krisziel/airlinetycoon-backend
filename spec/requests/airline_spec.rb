require 'rails_helper'

describe 'airtycoon API -- airline#' do

  it 'allows a new user to create an airline' do
    post '/airlines/',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1,
      'airline[user_id]' => 1
    }
    airline = JSON.parse(response.body)
    expect(airline["name"]).to eq('INnoVation Airlines')
  end

  it 'retreives a list of all airlines in the game' do
    post '/airlines/',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1,
      'airline[user_id]' => 1
    }
    post '/airlines/',
    {
      'airline[name]' => 'Jin Air',
      'airline[icao]' => 'MRU',
      'airline[game_id]' => 1,
      'airline[user_id]' => 2
    }
    get '/airlines/',
    {
      game_id:1
    }
    airlines = JSON.parse(response.body)
    expect(airlines[0]["name"]).to eq("INnoVation Airlines")
    expect(airlines[1]["name"]).to eq("Jin Air")
  end

  it 'returns an error when trying to create an airline with same name' do
    Airline.create!({name:"Jin Air",icao:"JNX",user_id:1,game_id:1,money:5})
    post '/airlines/',
    {
      'airline[name]' => 'Jin Air',
      'airline[icao]' => 'JNX',
      'airline[game_id]' => 1,
      'airline[user_id]' => 2
    }
    airlines = JSON.parse(response.body)
    expect(airlines["name"]).to eq(["An airline with that name already exists"])
    expect(airlines["icao"]).to eq(["An airline with that icao code already exists"])
  end

end
