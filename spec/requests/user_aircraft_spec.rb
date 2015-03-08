require 'rails_helper'

describe 'airtycoon API -- user_aircraft#' do

  before do
    get 'user/manuallogin'
    Game.create!(region:"all",year:"2Q2015")
    get 'games/manuallogin'
  end

  it 'can view all user aircraft (aircraft has name)' do
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:3)
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"j",name:"Herringbone",price:700,rating:7,sqft:15)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:20,p_count:80,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:40,p_count:60,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user/1'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list[0]["aircraft"]["name"]).to eq("777-200ER")
  end

  it 'can view all user aircraft (aircraft has configuration)' do
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:3)
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"j",name:"Herringbone",price:700,rating:7,sqft:15)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:20,p_count:80,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:40,p_count:60,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user/1'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list[0]["configuration"]["config"]["j"]["count"]).to eq(20)
  end

  it 'can view all user aircraft (list has both aircraft)' do
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:1,money:3)
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"j",name:"Herringbone",price:700,rating:7,sqft:15)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:20,p_count:80,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:40,p_count:60,y_count:400,f_seat:0,j_seat:3,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    UserAircraft.create(aircraft_id:2, airline_id:1, aircraft_configuration_id:1, age:1, inuse:false)
    get '/aircraft/user/1'
    aircraft_list = JSON.parse(response.body)
    expect(aircraft_list.length).to eq(2)
  end


  xit 'can create an aircraft' do

  end

  xit 'prevents a configuration designed for a different plane from being used' do

  end

end
