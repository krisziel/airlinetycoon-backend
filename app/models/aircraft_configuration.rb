class AircraftConfiguration < ActiveRecord::Base
  belongs_to :aircraft
  belongs_to :airline
  has_many :user_aircraft
  validates :name, uniqueness: {scope: [:airline_id, :aircraft_id], message:"A configuration with the same name already exists for this aircraft"}

  def config_details
    config = {
      id:id,
      name:name,
      config:{
        f:{
          count:f_count,
          seat:f_seat
        },
        j:{
          count:j_count,
          seat:j_seat
        },
        p:{
          count:p_count,
          seat:p_seat
        },
        y:{
          count:y_count,
          seat:y_seat
        }
      }
    }
    config
  end

end
