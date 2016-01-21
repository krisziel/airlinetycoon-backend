class MarketSize < ActiveRecord::Base
  belongs_to :marketable, polymorphic: true
  belongs_to :airline

  def data
    share_data = {
      airline: airline.basic_info,
      flights: flights,
      passengers: passengers,
      destinations: destinations,
      capacity: seats,
      asm: asm,
      rpm: rpm
    }
    share_data
  end

end
