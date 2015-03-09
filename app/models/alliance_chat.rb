class AllianceChat < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :airline

  def serialize
    chat = {
      airline:airline.basic_info,
      message:message
    }
    chat
  end

end
