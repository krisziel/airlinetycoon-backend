class ConversationController < ApplicationController
  before_action :game, :airline

  def all
    if airline
      conversation_list = airline.conversations
      conversations = []
      conversations.push(airline.game.last_message)
      if airline.alliance
        conversations.push(airline.alliance.last_message)
      end
      conversation_list.each do |conversation|
        conversations.push(conversation.last_message)
      end
      render json: conversations
    else
      render json: {error:'no airline'}, status: :unauthorized
    end
  end

  def create
    if airline
      existing_conversation = Conversation.find_by("recipient_id=? OR sender_id=?", airline.id, airline.id)
      if existing_conversation
        conversation = existing_conversation.last_message
        conversation["status"] = "conversation already exists"
      else
        conversation = Conversation.new(conversation_params)
        conversation.sender = airline
        if conversation.save
          conversation = conversation.last_message
        else
          conversation = conversation.errors.messages
        end
      end
    else
      conversation = {error:'no airline'}
    end
    render json: conversation
  end

  def show
    if airline
      conversation = Conversation.find(params[:id])
      if conversation.sender_id == airline.id || conversation.recipient_id == airline.id
        messages = conversation.messages
        message_list = []
        offset = params[:offset] || 0
        limit = params[:limit] || 20
        if params[:since]
          date =  Time.at(params[:since].to_i).to_datetime
          chats = conversation.messages.order(created_at: :asc).offset(offset).where('created_at > ?', date)
        else
          chats = conversation.messages.order(created_at: :asc).offset(offset)
        end
        chats.each do |chat|
          message_list.push(chat.serialize)
        end
        messages = message_list
      else
        messages = {error:'conversation does not belong to user'}
      end
    else
      messages = {
        error: "no airline"
      }
    end
    render json: messages
  end

  private
  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end

end
