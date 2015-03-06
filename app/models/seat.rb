class Seat < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :aircraft_configurations

  def seat_details
    seat = {
      name:name,
      id:id,
      rating:rating
    }
    seat
  end

end
