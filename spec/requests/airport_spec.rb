require 'rails_helper'

describe 'airtycoon API -- airport#' do

  before do
    Airport.create!({iata:"ROR",citycode:"ROR",name:"Airai Airport",city:"Koror",country:"Palau",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:7.364122,longitude:134.532892, display_year:1980})
    Airport.create!({iata:"YCG",citycode:"YCG",name:"Castlegar Airport",city:"Castlegar",country:"Canada",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:49.295556,longitude:-117.632222, display_year:1980})
    Airport.create!({iata:"RAN",citycode:"RAN",name:"La Spreta Airport",city:"Ravenna",country:"Italy",country_code:"",region:"EU",population:500000,slots_total:1989,slots_available:1213,latitude:44.366667,longitude:12.223333, display_year:1980})
    Airport.create!({iata:"TIS",citycode:"TIS",name:"Thursday Island Airport",city:"Thursday Island",country:"Australia",country_code:"",region:"AS",population:500000,slots_total:1989,slots_available:1213,latitude:-10.5,longitude:142.05, display_year:1980})
    Airport.create!({iata:"STU",citycode:"STU",name:"Santa Cruz Airport",city:"Santa Cruz",country:"Belize",country_code:"",region:"NA",population:500000,slots_total:1989,slots_available:1213,latitude:18.266667,longitude:-88.45, display_year:1980})
    Airport.create!({iata:"NNI",citycode:"NNI",name:"Namutoni Airport",city:"Namutoni",country:"Namibia",country_code:"",region:"AF",population:500000,slots_total:1989,slots_available:1213,latitude:-18.816667,longitude:16.916667, display_year:1980})
    Airport.create!({iata:"NGO",citycode:"NGO",name:"Chubu Centrair International Airport",city:"Nagoya",country:"Japan",country_code:"",region:"AS",population:2264000,slots_total:1989,slots_available:1213,latitude:34.858333,longitude:136.805278, display_year:1980})
    Airport.create!({iata:"JFK",citycode:"NYC",name:"John F. Kennedy International Airport",city:"New York",country:"United States",country_code:"",region:"NA",population:8406000,slots_total:1989,slots_available:1213,latitude:40.642335,longitude:-73.78817, display_year:1980})
    Airport.create!({iata:"EWR",citycode:"NYC",name:"Newark Liberty International Airport",city:"Newark",country:"United States",country_code:"",region:"NA",population:8406000,slots_total:1989,slots_available:1213,latitude:40.689071,longitude:-74.178753, display_year:1980})
  end

  it 'can get a list of all airports (gets the first airport)' do
    get 'airport'
    airports = JSON.parse(response.body)
    expect(airports[0]["iata"]).to eq("ROR")
  end

  it 'can get a list of all airports (gets the fourth airport)' do
    get 'airport'
    airports = JSON.parse(response.body)
    expect(airports[3]["iata"]).to eq("TIS")
  end

  it 'can get a list of all airports in a specific city (gets the right number of airports)' do
    get 'airport/city/NYC'
    airports = JSON.parse(response.body)
    expect(airports.length).to eq(2)
  end

  it 'can get a list of all airports in a specific city (has the proper info)' do
    get 'airport/city/NYC'
    airports = JSON.parse(response.body)
    expect(airports[1]["iata"]).to eq("EWR")
  end

  it 'can get a list of all airports in a specific city (gets the right number of airports)' do
    get 'airport/region/NA'
    airports = JSON.parse(response.body)
    expect(airports.length).to eq(4)
  end

  it 'can get a list of all airports in a specific city (has the proper info)' do
    get 'airport/region/NA'
    airports = JSON.parse(response.body)
    expect(airports[2]["iata"]).to eq("JFK")
  end

end
