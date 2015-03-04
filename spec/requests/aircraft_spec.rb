require 'rails_helper'

describe 'airtycoon API -- aircraft#' do

  it 'can get aircraft list' do
    Aircraft.create(name:"777-200ER",manufacturer:"Boeing",iata:"77E",capacity:440,speed:550,turn_time:90,price:261000000,discount:2,fuel_capacity:45250,range:8900,sqft:1980)
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    get '/aircraft'
    aircraft = JSON.parse(response.body)
    expect(aircraft[0]["name"]).to eq("777-200ER")
    expect(aircraft.length).to eq(3)
  end

  it 'can get a list of seat types' do
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    Seat.create(service_class:"p",name:"Economy Plus",price:700,rating:7,sqft:5)
    get '/aircraft/seats'
    seats = JSON.parse(response.body)
    expect(seats[0]["name"]).to eq("Economy")
    expect(seats.length).to eq(3)
  end

end
