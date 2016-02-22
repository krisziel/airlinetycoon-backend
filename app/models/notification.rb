class Notification < ActiveRecord::Base
	belongs_to :airline
	has_one :route
	has_one :flight
end
