class Message < ActiveRecord::Base
   belongs_to :airline
   validates_presence_of :body, :type_id, :message_type, :airline_id

   def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
   end

   def serialize
     sender_airline = Airline.find(airline_id).basic_info
     message = {
       body:body,
       sender:sender_airline,
       sent:created_at.to_i,
       type:message_type,
       typeId:type_id,
       id:id
     }
     message
   end

   def message_info perspective
     sender = perspective == airline_id ? true : false
     message = {
       body:body,
       sent:created_at.to_i,
       sender:sender,
       id:id
     }
     message
   end

end
