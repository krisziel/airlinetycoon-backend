class MarketSize < ActiveRecord::Base
  belongs_to :marketable, polymorphic: true
end
