class AllianceMembership < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :airline
end
