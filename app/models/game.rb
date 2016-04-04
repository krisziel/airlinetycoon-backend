class Game < ActiveRecord::Base
  has_many :airlines
  has_many :alliances
  has_many :game_chats

  def last_message
    message = Message.find_by(message_type:"Game", type_id:id)
    if message
      message = {
        body:message.body,
        sender:message.airline.basic_info,
        sent:message.created_at.to_i
      }
    else
      message = {
        body:"",
        sender:"",
        sent:0
      }
    end
    conversation = {
      message:message,
      recipient:basic_info,
    }
    conversation
  end

  def basic_info
    game = {
      name:name,
      id:id,
      region:region
    }
    game
  end

end
