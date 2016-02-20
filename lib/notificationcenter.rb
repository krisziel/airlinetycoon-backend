class NotificationCenter

  def initialize
    puts "hi"
  end

  def messages airline_id
    return Airline.find(airline_id)
  end

end
