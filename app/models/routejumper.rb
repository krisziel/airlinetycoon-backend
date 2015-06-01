class RouteJumper < ActiveRecord::Base

  def origin
    Airport.find(origin_id)
  end

  def destination
    Airport.find(destination_id)
  end

end
