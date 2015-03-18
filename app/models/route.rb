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
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare
    }
    route
  end

  def full_data
    route = {
      origin:origin.basic_data,
      destination:destination.basic_data,
      minfare:minfare,
      maxfare:maxfare,
      demand:demand,
      elasticity:elasticity,
      price:price
    }
    route
  end

end
