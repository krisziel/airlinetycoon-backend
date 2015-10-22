class Fare < ActiveRecord::Base
  belongs_to :airline
  belongs_to :route

  def details

    details = {
      route:route_id,
      fare:fare,
      passengers:passengers,
      revenue:revenue,
      routing:routing
    }
    details
  end

end

t.integer  "airline_id"
t.integer  "route_id"
t.json     "fare"
t.json     "passengers"
t.json     "revenue"
t.json     "routing"
