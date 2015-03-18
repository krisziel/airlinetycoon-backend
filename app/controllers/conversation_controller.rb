class ConversationController < ApplicationController
  before_action :airline

  def all
    conversation_list = Conversation.where("receipient_id=? OR sender_id=?", airline.id, airline.id)
    conversations = []
    conversation_list.each do |conversation|
      conversations.push(conversation.last_message)
    end
  end

  def show
    if airline.game
      message_list = []
      offset = params[:offset] || 0
      limit = params[:limit] || 20
      if params[:since]
        date =  Time.at(params[:since].to_i).to_datetime
        chats = airline.game.game_chats.order(created_at: :asc).where('created_at > ?', date)
      else
        chats = airline.game.game_chats.order(created_at: :asc).limit(limit).offset(offset)
      end
      chats.reverse.each do |chat|
        message_list.push(chat.serialize)
      end
      messages = message_list
    else
      messages = {
        error: "no alliance"
      }
    end
    render json: messages
  end

end
