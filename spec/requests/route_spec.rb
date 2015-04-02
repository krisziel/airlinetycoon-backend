require 'rails_helper'

describe 'airtycoon API -- route#' do

  before do
    get 'user/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    get 'games/manuallogin'
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:User.last.id,game_id:1,money:500)
    origin = Airport.new({iata:"ROR",citycode:"ROR",name:"Airai Airport",city:"Koror",country:"Palau",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:7.364122,longitude:134.532892, display_year:1980})
    destination = Airport.new({iata:"YCG",citycode:"YCG",name:"Castlegar Airport",city:"Castlegar",country:"Canada",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:49.295556,longitude:-117.632222, display_year:1980})
    origin.save
    destination.save
    route = Route.new({
      origin_id:origin.id,
      destination_id:destination.id,
      distance:6624,
      minfare:{
        f:500,
        j:400,
        p:250,
        y:175
      },
      maxfare:{
        f:1500,
        j:1350,
        p:1150,
        y:1050
      },
      price:{
        f:950,
        j:900,
        p:850,
        y:800
      },
      demand:{
        f:50,
        j:120,
        p:400,
        y:1000
      },
      elasticity:{
        f:'a',
        j:'b',
        p:'c',
        y:'d'
      }
    })
    route.save
  end

  it 'can get data for a route (origin airport)' do
    url = "route/#{Route.last.id}"
    get url
    response_json = JSON.parse(response.body)
    expect(response_json["origin"]["iata"]).to eq("ROR")
  end

  it 'can get data for a route (destination airport)' do
    url = "route/#{Route.last.id}"
    get url
    response_json = JSON.parse(response.body)
    expect(response_json["destination"]["iata"]).to eq("YCG")
  end

  it 'can get data for a route (max fare)' do
    url = "route/#{Route.last.id}"
    get url
    response_json = JSON.parse(response.body)
    expect(response_json["maxfare"]["f"]).to eq(1500)
  end

  it 'can get data for all flights on a route (proper number of flights)' do
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:2,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:2,user_aircraft_id:2,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    url = "route/#{Route.last.id}"
    get url
    route = JSON.parse(response.body)
    expect(route["flights"].length).to eq(2)
  end

  it 'can get data for all flights on a route (correct flight detail)' do
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:2,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:2,user_aircraft_id:2,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    url = "route/#{Route.last.id}"
    get url
    route = JSON.parse(response.body)
    expect(route["flights"][0]["airline"]).to eq({"name"=>"INnoVation Airlines", "icao"=>"INO", "id"=>1})
  end

end
