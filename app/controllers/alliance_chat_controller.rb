class AllianceChatController < ApplicationController
  before_action :airline, :game

  def all
    if airline.alliance
      message_list = []
      offset = params[:offset] || 0
      limit = params[:limit] || 20
      if params[:since]
        p params[:since].to_i
        chats = airline.alliance.alliance_chats.order(created_at: :asc).where('created_at > ?', DateTime.strptime(params[:since].to_i,"%s"))
      else
        chats = airline.alliance.alliance_chats.order(created_at: :asc).limit(limit).offset(offset)
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
