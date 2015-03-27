require 'rails_helper'

describe 'airtycoon API -- aircraft#' do
  before do
    get 'user/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    get 'games/manuallogin'
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:User.last.id,game_id:1,money:500)
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
  end

  it 'can get aircraft list (aircraft has name)' do
    get '/aircraft'
    aircraft = JSON.parse(response.body)
    expect(aircraft[0]["name"]).to eq("777-200ER")
  end

  it 'can get aircraft list (list has all aircraft)' do
    get '/aircraft'
    aircraft = JSON.parse(response.body)
    expect(aircraft.length).to eq(3)
  end

  it 'can get get the generated aircraft object' do
    get '/aircraft'
    aircraft = JSON.parse(response.body)
    expect(aircraft[0]["user"]).to eq({"inuse" => 0,"unused" => 0, "aircraft"=>[]})
  end

  it 'can get a list of seat types (the seat has a name)' do
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"p",name:"Economy Plus",price:700,rating:7,sqft:5)
    get '/aircraft/seats'
    seats = JSON.parse(response.body)
    expect(seats[0]["name"]).to eq("Economy")
  end

  it 'can get a list of seat types (the list has all seat types)' do
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"p",name:"Economy Plus",price:700,rating:7,sqft:5)
    get '/aircraft/seats'
    seats = JSON.parse(response.body)
    expect(seats.length).to eq(3)
  end

end
