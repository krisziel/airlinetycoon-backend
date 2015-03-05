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
      full_name:full_name
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
      sqft:sqft
    }
  end

end
