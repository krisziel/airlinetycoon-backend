class GameChat < ActiveRecord::Base
  belongs_to :game
  belongs_to :airline

  def serialize
    chat = {
      airline:airline.basic_info,
      message:message
    }
    chat
  end
end
