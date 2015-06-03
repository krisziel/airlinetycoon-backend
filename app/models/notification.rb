class Notification < ActiveRecord::Base
	has_one :airline
	has_one :route
	has_one :flight
end
