class NotificationCenter

  def initialize
  end

  def notifications airline_id, last_update
    airline = Airline.find(airline_id)
    notification_list = airline.notifications.where("updated_at > ?", last_update)
    notifications = []
    if notification_list.length > 0
      airline.update(last_update: Time.now.to_i)
      notification_list.each do |notification|
        notifications.push notification.serialize
      end
    end
    return notifications
  end

end
