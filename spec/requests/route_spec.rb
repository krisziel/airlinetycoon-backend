require 'rails_helper'

describe 'airtycoon API -- route#' do

  before do
    origin = Airport.new({iata:"ROR",citycode:"ROR",name:"Airai Airport",city:"Koror",country:"Palau",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:7.364122,longitude:134.532892, display_year:1980})
    destination = Airport.new({iata:"YCG",citycode:"YCG",name:"Castlegar Airport",city:"Castlegar",country:"Canada",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:49.295556,longitude:-117.632222, display_year:1980})
    origin.save
    destination.save
    route = Route.new({
      origin_id:origin.id,
      destination_id:destination.id,
      distance:6624,
      minfare_json:{
        f:500,
        j:400,
        p:250,
        y:175
      },
      maxfare_json:{
        f:1500,
        j:1350,
        p:1150,
        y:1050
      },
      price_json:{
        f:950,
        j:900,
        p:850,
        y:800
      },
      demand_json:{
        f:50,
        j:120,
        p:400,
        y:1000
      },
      elasticity_json:{
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

end
