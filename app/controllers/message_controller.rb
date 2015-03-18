class MessageController < ApplicationController
  before_action :airline

  def create
    if airline
      message = Message.new(message_params)
      message.airline = airline
      if message.save
        message
      else
        message = message.errors.messages
      end
    else
      message = {error:'no airline'}
    end
    render json: message
  end

  private
  def message_params
    params.require(:message).permit(:body, :conversation_id)
  end

end
