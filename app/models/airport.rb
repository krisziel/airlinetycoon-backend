class Airport < ActiveRecord::Base

  def serialize
    airport = {
      iata:iata,
      cityCode:citycode,
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
      },
      id:id
    }
    airport
  end

  def basic_data
    airport = {
      iata:iata,
      name:name,
      city:city,
      country:country,
      id:id
    }
    airport
  end

  def simple
    import = {
      iata:iata,
      name:name,
      id:id
    }
    import
  end

end
