class AllianceChat < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :airline
  validates :message, :airline_id, :alliance_id, presence: true

  def serialize
    chat = {
      airline:airline.basic_info,
      message:message
    }
    chat
  end

end
