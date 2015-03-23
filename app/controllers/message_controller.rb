class MessageController < ApplicationController
  before_action :airline

  def create
    if airline
      conversation = Conversation.find(params[:id])
      if conversation.sender_id == airline.id || conversation.recipient_id == airline.id
        if params[:message][:body] == ""
          message = {error:'empty message'}
        else
          date =  Time.now.to_datetime-15
          dupe = conversation.messages.find_by('created_at > ? AND body=?', date, params[:message][:body])
          if dupe
            message = {error:'duplicate message'}
          else
            message = conversation.messages.new(message_params)
            message.airline = airline
            if message.save
              message = message.serialize
              message[:sender] == airline.id ? message[:own] = true : message[:own] = false
            else
              message = message.errors.messages
            end
          end
        end
      else
        messages = {error:'conversation does not belong to user'}
      end
    else
      message = {error:'no airline'}
    end
    render json: message
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

end
