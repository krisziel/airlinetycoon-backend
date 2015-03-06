class UserAircraft < ActiveRecord::Base
  belongs_to :airline
  belongs_to :aircraft_configuration
  belongs_to :aircraft

  def full_data
    {
      id:id,
      aircraft:aircraft.tech_info,
      inuse:inuse,
      configuration:aircraft_configuration.config_details
    }
  end
end
