class Message < ActiveRecord::Base
   belongs_to :conversation
   belongs_to :airline
   validates_presence_of :body, :conversation_id, :airline_id

   def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
   end

   def serialize
     message = {
       body:body,
       sender:airline_id,
       sent:created_at.to_i
     }
     message
   end

end
