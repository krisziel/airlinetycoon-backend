class NotificationCenter

  def initialize
  end

  def notifications airline_id, last_update
    Airline.notifications.where("updated_at > ?", last_update)
    if notifications.length > 0
      Airline.find(airline_id).update(last_update: Time.now.to_i)
    end
    return notifications
  end

end
