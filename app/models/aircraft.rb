class Aircraft < ActiveRecord::Base
  validates :iata, uniqueness: :true
  has_many :user_aircrafts

  def full_name
    "#{manufacturer} #{name}"
  end

  def basic_info
    {
      name:name,
      manufacturer:manufacturer,
      iata:iata,
      full_name:full_name,
      id:id
    }
  end

  def tech_info
    {
      name:name,
      manufacturer:manufacturer,
      iata:iata,
      full_name:full_name,
      capacity:capacity,
      range:range,
      speed:speed,
      turn_time:turn_time,
      sqft:sqft,
      id:id
    }
  end

end
