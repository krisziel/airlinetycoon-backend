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
      render json: { error:'no airline' }, status: :unauthorized
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
      message_list = []
      offset = params[:offset] || 0
      limit = params[:limit] || 20
      id = params[:id]
      query = nil
      if id == "alliance"
        alliance = airline.alliance
        if alliance
          query = Message.where(message_type:"Alliance", type_id:alliance.id)
          info = {
            id:alliance.id,
            type:"alliance",
            recipient:alliance.name
          }
        else
          render json: { error:'no alliance' }, status: :unauthorized
        end
      elsif id == "game"
        query = Message.where(message_type:"Game", type_id:game.id)
        info = {
          id:game.id,
          type:"game",
          recipient:game.name
        }
      elsif Conversation.find(id)
        conversation = Conversation.find(id)
        if conversation.sender_id == airline.id || conversation.recipient_id == airline.id
          query = Message.where(message_type:"Conversation", type_id:id)
          recipient_id = conversation.sender_id == airline.id ? conversation.recipient_id : conversation.sender_id
          recipient = Airline.find(recipient_id)
          info = {
            id:conversation.id,
            type:"airline",
            recipient:recipient.basic_info
          }
        else
          render json: { error:'no permission' }, status: :unauthorized
        end
      else
        render json: { error:'no request' }, status: :unauthorized
      end
      messages = query.order(created_at: :asc).offset(offset).limit(limit)
      if messages
        messages = messages.map{|m| m.message_info airline.id }
      end
      render json: { info:info, messages:messages }
    else
      render json: { error:'no airline' }, status: :unauthorized
    end
  end

end
