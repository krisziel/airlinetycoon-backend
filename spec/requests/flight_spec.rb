require 'rails_helper'

describe 'airtycoon API -- flight#' do

  before do
    get 'user/manuallogin'
    get 'games/manuallogin'
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:User.last.id,game_id:1,money:500)
    ror = Airport.new!({iata:"ROR",citycode:"ROR",name:"Airai Airport",city:"Koror",country:"Palau",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:7.364122,longitude:134.532892, display_year:1980})
    ycg = Airport.new!({iata:"YCG",citycode:"YCG",name:"Castlegar Airport",city:"Castlegar",country:"Canada",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:49.295556,longitude:-117.632222, display_year:1980})
    ran = Airport.new!({iata:"RAN",citycode:"RAN",name:"La Spreta Airport",city:"Ravenna",country:"Italy",country_code:"",region:"EU",population:500000,slots_total:1989,slots_available:1213,latitude:44.366667,longitude:12.223333, display_year:1980})
    tis = Airport.new!({iata:"TIS",citycode:"TIS",name:"Thursday Island Airport",city:"Thursday Island",country:"Australia",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:-10.5,longitude:142.05, display_year:1980})
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

  xit 'cannot create a flight with no aircraft' do
  end

  xit 'cannot create a flight with an aircraft already in use' do
  end

  xit 'cannot create a flight with an aircraft without required range' do
  end

  xit 'cannot create a flight with another airline\'s aircraft' do
  end

  xit 'cannot create a flight with more frequencies than plane can handle' do
  end

  xit 'cannot create a flight with fare outside the limits (fare cannot be too high)' do
  end

  xit 'cannot create a flight with fare outside the limits (fare cannot be too low)' do
  end

  xit ' can create a flight within all limitations' do
  end

  xit 'can retreive details for a single flight' do
  end

  xit 'cannot update a flight with no aircraft' do
  end

  xit 'cannot update a flight with an aircraft already in use' do
  end

  xit 'cannot update a flight with an aircraft without required range' do
  end

  xit 'cannot update a flight with another airline\'s aircraft' do
  end

  xit 'cannot update a flight with more frequencies than plane can handle' do
  end

  xit 'cannot update a flight with fare outside the limits (fare cannot be too high)' do
  end

  xit 'cannot update a flight with fare outside the limits (fare cannot be too low)' do
  end

end
