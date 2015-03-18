require 'rails_helper'

describe 'airtycoon API -- flight#' do

  before do
    get 'user/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    get 'games/manuallogin'
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:User.last.id,game_id:1,money:500)
    Aircraft.create(name:"777-200LR",manufacturer:"Boeing",iata:"77L",capacity:440,speed:550,turn_time:90,price:296000000,discount:2,fuel_capacity:47900,range:10800,sqft:1980)
    Aircraft.create(name:"777-300ER",manufacturer:"Boeing",iata:"77W",capacity:550,speed:550,turn_time:90,price:320000000,discount:2,fuel_capacity:47900,range:9100,sqft:2475)
    Aircraft.create(name:"757-200",manufacturer:"Boeing",iata:"752",capacity:239,speed:530,turn_time:50,price:65000000,discount:2,fuel_capacity:11500,range:4700,sqft:1076)
    Seat.create(service_class:"y",name:"Economy",price:500,rating:7,sqft:4.5)
    Seat.create(service_class:"p",name:"Premium Economy",price:1000,rating:9,sqft:7)
    AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    AircraftConfiguration.create(name:"High Density",aircraft_id:3,airline_id:1,f_count:0,j_count:0,p_count:24,y_count:130,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
    ror = Airport.new({iata:"ROR",citycode:"ROR",name:"Airai Airport",city:"Koror",country:"Palau",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:7.364122,longitude:134.532892, display_year:1980})
    ycg = Airport.new({iata:"YCG",citycode:"YCG",name:"Castlegar Airport",city:"Castlegar",country:"Canada",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:49.295556,longitude:-117.632222, display_year:1980})
    ran = Airport.new({iata:"RAN",citycode:"RAN",name:"La Spreta Airport",city:"Ravenna",country:"Italy",country_code:"",region:"EU",population:500000,slots_total:1989,slots_available:1213,latitude:44.366667,longitude:12.223333, display_year:1980})
    tis = Airport.new({iata:"TIS",citycode:"TIS",name:"Thursday Island Airport",city:"Thursday Island",country:"Australia",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:-10.5,longitude:142.05, display_year:1980})
    ror.save
    ycg.save
    ran.save
    tis.save
    rorycg = Route.new({
      origin_id:ror.id,
      destination_id:ycg.id,
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
    ycgran = Route.new({
      origin_id:ycg.id,
      destination_id:ran.id,
      distance:5309,
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
    rantis = Route.new({
      origin_id:ran.id,
      destination_id:tis.id,
      distance:8674,
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
    tisror = Route.new({
      origin_id:tis.id,
      destination_id:ror.id,
      distance:1344,
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
    rorycg.save
    ycgran.save
    rantis.save
    tisror.save
  end

  it 'cannot create a flight on a route that doesn\'t exist' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:7,
        user_aircraft_id:0,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("route does not exist")
  end

  it 'cannot create a flight with an aircraft that doesn\'t exist' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:0,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("aircraft does not exist")
  end

  it 'cannot create a flight with an aircraft already in use' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("aircraft is already in use")
  end

  it 'cannot create a flight with an aircraft without required range' do
    UserAircraft.create(aircraft_id:3,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("flight is longer than aircraft range")
  end

  it 'cannot create a flight with another airline\'s aircraft' do
    UserAircraft.create(aircraft_id:2,airline_id:2,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("aircraft does not belong to airline")
  end

  it 'cannot create a flight with more frequencies than plane can handle' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:50,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("more frequencies than aircraft can fly")
  end

  it 'cannot create a flight with fare outside the limits (fare cannot be too high)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:9180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("y fare too high")
  end

  it 'cannot create a flight with fare outside the limits (fare cannot be too low)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:2
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("y fare too low")
  end

  it 'can create a flight within all limitations' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    post 'flight',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:500
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight["id"]).to be(1)
  end

  it 'cannot update a flight with an aircraft already in use' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:2,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("aircraft is already in use")
  end

  it 'cannot update a flight with an aircraft without required range' do
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:3,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:2,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("flight is longer than aircraft range")
  end

  it 'cannot update a flight with another airline\'s aircraft' do
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:2,airline_id:2,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:2,
        frequencies:4,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("aircraft does not belong to airline")
  end

  it 'cannot update a flight with more frequencies than plane can handle' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:50,
        fare:{
          f:505,
          j:405,
          p:255,
          y:180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("more frequencies than aircraft can fly")
  end

  it 'cannot update a flight with fare outside the limits (fare cannot be too high)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:9180
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("y fare too high")
  end

  it 'cannot update a flight with fare outside the limits (fare cannot be too low)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:2
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight).to include("y fare too low")
  end

  it 'can update a flight within all limitations (changing aircraft)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:2,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:500
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight["id"]).to be(1)
  end

  it 'can update a flight within all limitations (not changing aircraft)' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    put 'flight/1',
    {
      flight:{
        route_id:1,
        user_aircraft_id:1,
        frequencies:2,
        fare:{
          f:500,
          j:500,
          p:500,
          y:500
        }
      }
    }
    flight = JSON.parse(response.body)
    expect(flight["id"]).to be(1)
  end

  it 'can retreive details for a single flight' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    get 'flight/1'
    flight = JSON.parse(response.body)
    expect(flight["route"]["origin"]["iata"]).to eq("ROR")
  end

  it 'can retreive all of an airline\'s flights of an aircraft type' do
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:false)
    UserAircraft.create(aircraft_id:1,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    UserAircraft.create(aircraft_id:2,airline_id:1,aircraft_configuration_id:1,age:0,inuse:true)
    Flight.create(airline_id:1,route_id:1,user_aircraft_id:1,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:2,user_aircraft_id:2,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:2,user_aircraft_id:3,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    Flight.create(airline_id:1,route_id:3,user_aircraft_id:4,frequencies:2,fare:{f:500,j:500,p:500,y:500})
    get 'flight/aircraft/77L'
    flights = JSON.parse(response.body)
    expect(flights[0]["route"]["origin"]["iata"]).to eq("ROR")
  end

  it 'can retreive all flights from a single airport' do

  end

end
