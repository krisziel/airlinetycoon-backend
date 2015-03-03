require 'rails_helper'

describe 'airlinetycoon API -- airline#' do

  it 'allows a new user to create an airline' do
    post '/airline/create',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1,
      'airline[user_id]' => 1,
    }
    airline = JSON.parse(response.body)
    expect(airline["airline"]["name"]).to eq('INnoVation Airlines')
  end

  it 'retreives a list of all airlines in the game' do
    post '/airline/create',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1,
      'airline[user_id]' => 1
    }
    post '/airline/create',
    {
      'airline[name]' => 'Jin Air',
      'airline[icao]' => 'MRU',
      'airline[game_id]' => 1,
      'airline[user_id]' => 2
    }
    get '/airline/all'
    airlines = JSON.parse(response.body)
    expect(airlines["airline"][0]["name"]).to eq("INnoVation Airlines")
    expect(airlines["airline"][1]["name"]).to eq("Jin Air")
  end

end
