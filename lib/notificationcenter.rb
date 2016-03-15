class NotificationCenter

  def initialize
  end

  def notifications airline_id, last_update
    airline = Airline.find(airline_id)
    notifications = airline.notifications.where("updated_at > ?", last_update)
    if notifications.length > 0
      airline.update(last_update: Time.now.to_i)
    end
    return notifications
  end

end
