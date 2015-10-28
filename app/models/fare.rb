class Fare < ActiveRecord::Base
  belongs_to :airline
  belongs_to :route
  has_many :fare_routings
  validates :route_id, uniqueness: {scope: [:airline_id], message:"Fare already exists for this route"}

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
