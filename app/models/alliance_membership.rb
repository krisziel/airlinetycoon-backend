class AllianceMembership < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :airline
  validates :airline_id, uniqueness: true
end
