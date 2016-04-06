class Alliance < ActiveRecord::Base
  belongs_to :game
  has_many :airlines, through: :alliance_memberships
  has_many :alliance_memberships
  has_many :alliance_chats
  validates :name, presence: true
  validates :name, uniqueness: {scope: :game_id, message:'An alliance with that name already exists'}

  def last_message
    message = Message.find_by(message_type:"Alliance", type_id:id)
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
      id:"alliance"
    }
    conversation
  end

  def basic_info
    alliance = {
      name:name,
      id:id
    }
    alliance
  end

end
