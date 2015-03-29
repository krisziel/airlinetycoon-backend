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
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
  end

  it 'can retreive a list of configurations beloning to an airline (the aircrafft name is returned)' do
    get 'aircraft/configs'
    configurations = JSON.parse(response.body)
    expect(configurations[0]["aircraft"]["name"]).to eq("777-200LR")
  end

  it 'can retreive a list of configurations beloning to an airline (the class name is returned)' do
    get 'aircraft/configs'
    configurations = JSON.parse(response.body)
    expect(configurations[1]["seats"]["p"]["name"]).to eq("Premium Economy")
  end

  it 'can retreive a list of configurations belonging to an airline and aircraft type (the list of all of the airlines\' configurations)' do
    get 'aircraft/configs/77W'
    configurations = JSON.parse(response.body)
    expect(configurations.length).to eq(1)
  end

  it 'can retreive a list of configurations belonging to an airline and aircraft type (the data for the aircraft a configuration belongs to is correct)' do
    get 'aircraft/configs/77W'
    configurations = JSON.parse(response.body)
    expect(configurations[0]["aircraft"]["iata"]).to eq("77W")
  end

  it 'can create a new configuration' do
    post 'aircraft/configs',
    {
      config:{
        name:'Pretty High Density',
        aircraft_id:1,
        seats:JSON.parse('{"count":{"f":0,"j":0,"p":80,"y":300},"id":{"f":0,"j":0,"p":2,"y":1}}')
      }
    }
    configuration = JSON.parse(response.body)
    expect(configuration["seats"]["y"]["count"]).to eq(300)
  end

  it 'can delete a configuration' do
    AircraftConfiguration.create(name:"Highest Density",aircraft_id:2,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    delete 'aircraft/configs/3'
    configuration = JSON.parse(response.body)
    expect(configuration["message"]).to eq("configuration deleted")
  end

  it 'cannot delete a configuration used by aircraft' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    delete 'aircraft/configs/1'
    configuration = JSON.parse(response.body)
    expect(configuration["aircraft"].length).to eq(1)
  end

  it 'prevents a configuration from having the same name as another of the type' do
    post 'aircraft/configs',
    {
      config:{
        name:'High Density',
        aircraft_id:1,
        seats:JSON.parse('{"count":{"f":0,"j":0,"p":80,"y":300},"id":{"f":0,"j":0,"p":2,"y":1}}')
      }
    }
    configuration = JSON.parse(response.body)
    expect(configuration["name"]).to eq(["A configuration with the same name already exists for this aircraft"])
  end

  it 'prevents the configuration from having more seats than aircraft capacity' do
    post 'aircraft/configs',
    {
      config:{
        name:'Pretty High Density',
        aircraft_id:1,
        seats:JSON.parse('{"count":{"f":0,"j":0,"p":80,"y":315},"id":{"f":0,"j":0,"p":2,"y":1}}')
      }
    }
    configuration = JSON.parse(response.body)
    expect(configuration["seats"]["y"]["count"]).to eq(315)
  end

end
