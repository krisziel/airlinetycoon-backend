class Notification < ActiveRecord::Base
	belongs_to :airline
	has_one :route
	has_one :flight

	def serialize
		data = {
			header: header,
			description: text,
			type: notificationable_type,
			typeId: notificationable_id,
			id: id
		}
		return data
	end

end
