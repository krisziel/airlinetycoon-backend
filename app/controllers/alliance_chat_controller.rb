class AllianceChatController < ApplicationController
  before_action :airline, :game

  def all
    if airline.alliance
      message_list = []
      offset = params[:offset] || 0
      limit = params[:limit] || 20
      if params[:since]
        date =  Time.at(params[:since].to_i).to_datetime
        chats = airline.alliance.alliance_chats.order(created_at: :asc).where('created_at > ?', date)
      else
        chats = airline.alliance.alliance_chats.order(created_at: :asc).limit(limit).offset(offset)
      end
      chats.each do |chat|
        message = chat.serialize
        message[:airline][:id] == airline.id ? message[:own] = true : message[:own] = false
        message_list.push(message)
      end
      messages = message_list
    else
      messages = {
        error: "no alliance"
      }
    end
    render json: messages
  end

  def create
    if airline.alliance
      params[:alliance_chat][:airline_id] = airline.id
      message = airline.alliance.alliance_chats.new(message_params)
      if message.save
        messages = message.serialize
      else
        messages = message.errors.messages
      end
    else
      messages = {
        error: "no alliance"
      }
    end
    render json: messages
  end

  private
  def message_params
    params.require(:alliance_chat).permit(:message, :airline_id)
  end

end
