class Aircraft < ActiveRecord::Base
  validates :iata, uniqueness: :true

  def full_name
    "#{manufacturer} #{name}"
  end

end
