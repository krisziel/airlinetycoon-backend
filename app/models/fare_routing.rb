class FareRouting < ActiveRecord::Base
  belongs_to :fare, :dependent => :destroy
  has_many :flight_loads

end
