class GameChat < ActiveRecord::Base
  belongs_to :game
  belongs_to :airline
  validates :message, :game_id, :airline_id, presence: true

  def serialize
    chat = {
      airline:airline.basic_info,
      message:message
    }
    chat
  end
end
