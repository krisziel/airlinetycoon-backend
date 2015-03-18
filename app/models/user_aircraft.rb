class UserAircraft < ActiveRecord::Base
  belongs_to :airline
  belongs_to :aircraft_configuration
  belongs_to :aircraft
  has_many :flights

  def full_data
    user_aircraft = {
      id:id,
      aircraft:aircraft.tech_info,
      inuse:inuse,
      configuration:aircraft_configuration.config_details
    }
    user_aircraft
  end

  def config
    config = {
      id:id,
      configuration:aircraft_configuration.config_details
    }
    config
  end

end
