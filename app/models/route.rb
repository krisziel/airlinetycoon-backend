class Route < ActiveRecord::Base
  has_many :flights

  def origin
    Airport.find(origin_id)
  end

  def destination
    Airport.find(destination_id)
  end

  def serialize
    route = {
      origin:origin,
      destination:destination,
      minfare:minfare_json,
      maxfare:maxfare_json,
      demand:demand_json,
      elasticity:elasticity_json,
      price:price_json
    }
    route
  end

end
