class Airport < ActiveRecord::Base
  has_many :market_sizes, as: :marketable
  belongs_to :city

  def serialize
    airport = {
      iata: iata,
      cityCode: citycode,
      name: name,
      city: city,
      state: state,
      country: country,
      population: population,
      slots: {
        total: slots_total,
        available: slots_available
      },
      coordinates: {
        latitude: latitude,
        longitude: longitude
      },
      id: id
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

  def market_share_data game_id
    airport_shares = self.market_sizes.where("airline_id IN (?)", Game.find(game_id).airlines.pluck(:id))
    all_shares = []
    airport_shares.each do |share|
      all_shares.push share.data
    end
    share_data = {
      airport: self.market_sizes.find_by(game_id: game_id).airport_data,
      airlines: all_shares
    }
    share_data
  end

end
