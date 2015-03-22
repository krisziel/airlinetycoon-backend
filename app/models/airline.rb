class Airline < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :configurations
  has_many :user_aircrafts
  has_many :alliance_chats
  has_many :flights
  has_one :alliance_membership
  has_one :alliance, through: :alliance_membership

  validates :name, :icao, :user_id, :game_id, presence: true
  validates :name, uniqueness: {scope: :game_id, message:'An airline with that name already exists'}
  validates :icao, uniqueness: {scope: :game_id, message:'An airline with that code already exists'}

  def basic_info
    airline = {
      name:name,
      icao:icao,
      id:id
    }
    airline
  end

  def conversations
    Conversation.where("sender_id=? OR recipient_id=?",id,id)
  end

end
