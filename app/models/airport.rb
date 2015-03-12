class Airport < ActiveRecord::Base

  def serialize
    airport = {
      iata:iata,
      icao:icao,
      citycode:citycode,
      name:name,
      city:city,
      state:state,
      country:country,
      population:population,
      slots:{
        total:slots_total,
        available:slots_available
      },
      coordinates:{
        latitude:latitude,
        longitude:longitude
      }
    }
    airport
  end

end
