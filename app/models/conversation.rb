class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'Airline'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'Airline'
  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, :scope => :recipient_id
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  def last_message
    message = messages.last
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
      sender:sender.basic_info,
      recipient:recipient.basic_info,
    }
    conversation
  end

end
