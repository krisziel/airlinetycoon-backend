require 'rails_helper'

describe 'airtycoon API -- user_aircraft#' do

  before do
    get 'user/manuallogin'
    get 'games/manuallogin'
    Game.create(region:'asia',year:'2Q2015')
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:1,game_id:1,money:500)
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:nil,j_seat:nil,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:nil,j_seat:nil,p_seat:2,y_seat:1)
  end

  it 'can retreive a list of configurations beloning to an airline' do
    get 'aircraft/user/1/configs'
    configurations = JSON.parse(response.body)
    expect(configurations[0]["aircraft"]["name"]).to eq("777-200LR")
    expect(configurations[1]["seats"]["p"]["name"]).to eq("Premium Economy")
  end

  it 'can retreive a list of configurations belonging to an airline and aircraft type' do
    get 'aircraft/user/1/configs/77W'
    configurations = JSON.parse(response.body)
    expect(configurations.length).to eq(1)
    expect(configurations[0]["aircraft"]["iata"]).to eq("77W")
  end

  it 'can create a new configuration' do
    post 'aircraft/user/1/configs',
    {
      name:'High Density',
      aircraft_id:1,
      
    }
  end

  xit 'prevents a configuration designed for a different plane from being used' do

  end

  xit 'can delete a configuration' do

  end

  xit 'prevents a configuration from having the same name as another of the type' do

  end

  xit 'prevents the configuration from having more seats than aircraft capacity' do

  end

end
