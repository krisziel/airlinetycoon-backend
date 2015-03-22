require 'rails_helper'

describe 'airtycoon API -- airline#' do
  before do
    get 'user/manuallogin'
  end

  it 'allows a new user to create an airline' do
    post '/airline/',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1
    }
    airline = JSON.parse(response.body)
    expect(airline["name"]).to eq('INnoVation Airlines')
  end

  it 'retreives a list of all airlines in the game (an airline has a name)' do
    Game.create!(region:'world')
    post '/airline/',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1
    }
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:3)
    get 'airline/'
    airlines = JSON.parse(response.body)
    expect(airlines[1]["name"]).to eq("Maru Airways")
  end

  it 'retreives a list of all airlines in the game (this list has all airlines)' do
    Game.create!(region:'world')
    post '/airline/',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[icao]' => 'INO',
      'airline[game_id]' => 1
    }
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:3)
    get 'airline/'
    airlines = JSON.parse(response.body)
    expect(airlines.length).to eq(2)
  end

  it 'returns an error when trying to create an airline with same name' do
    Airline.create!({name:"Jin Air",icao:"JNX",user_id:1,game_id:1,money:5})
    post 'airline/',
    {
      'airline[name]' => 'Jin Air',
      'airline[icao]' => 'JNX',
      'airline[game_id]' => 1,
      'airline[user_id]' => 2
    }
    airlines = JSON.parse(response.body)
    expect(airlines["name"]).to eq(["An airline with that name already exists"])
  end

  it 'returns an error when trying to create an airline with same icao code' do
    Airline.create!({name:"Jin Air",icao:"JNX",user_id:1,game_id:1,money:5})
    post 'airline/',
    {
      'airline[name]' => 'Jin Air',
      'airline[icao]' => 'JNX',
      'airline[game_id]' => 1,
      'airline[user_id]' => 2
    }
    airlines = JSON.parse(response.body)
    expect(airlines["icao"]).to eq(["An airline with that code already exists"])
  end

end
