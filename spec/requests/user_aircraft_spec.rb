require 'rails_helper'

describe 'airtycoon API -- user_aircraft#' do

  before do
    get 'user/manuallogin'
    Game.create!(region:"all",year:"2Q2015")
    get 'games/manuallogin'
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:1000000000)
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"j",name:"Herringbone",price:700,rating:7,sqft:15)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:20,p_count:80,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:40,p_count:60,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
  end

  it 'can view all user aircraft (aircraft has name)' do
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list["1"]["aircraft"]["name"]).to eq("777-200ER")
  end

  it 'can view all user aircraft (aircraft has configuration)' do
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list["1"]["configuration"]["config"]["j"]["count"]).to eq(20)
  end

  it 'can view all user aircraft (list has both aircraft)' do
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list.length).to eq(2)
  end

  it 'can create an aircraft' do
    post '/aircraft/user',
    {
      aircraft_id:1,
      configuration_id:1,
      quantity:1
    }
    purchase = JSON.parse(response.body)
    expect(purchase[0]["aircraft"]["name"]).to eq("777-200ER")
  end

  it 'prevents a configuration designed for a different plane from being used' do
    post '/aircraft/user',
    {
      aircraft_id:1,
      configuration_id:2,
      quantity:1
    }
    purchase = JSON.parse(response.body)
    expect(purchase["error"]).to eq("selected configuration does not aircraft type")
  end

  it 'prevents a user from buying more planes than they can afford' do
    post '/aircraft/user',
    {
      aircraft_id:1,
      configuration_id:1,
      quantity:30
    }
    purchase = JSON.parse(response.body)
    expect(purchase["error"]).to eq("user does not have enough money for selected quantity")
  end

  it 'can update an aircraft' do
    UserAircraft.create(aircraft_id:1,aircraft_configuration_id:1,inuse:false,age:0)
    AircraftConfiguration.create!(name:"Business",aircraft_id:1,airline_id:1,f_count:0,j_count:40,p_count:20,y_count:300,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    put '/aircraft/user',
    {
      id:1,
      configuration_id:3,
    }
    purchase = JSON.parse(response.body)
    expect(purchase["aircraft"]["name"]).to eq("777-200ER")
  end

  it 'prevents a configuration designed for a different plane from being used when updating' do
    UserAircraft.create(aircraft_id:1,aircraft_configuration_id:1,inuse:false,age:0)
    put '/aircraft/user',
    {
      id:1,
      configuration_id:2
    }
    purchase = JSON.parse(response.body)
    expect(purchase["error"]).to eq("selected configuration does not aircraft type")
  end

end
