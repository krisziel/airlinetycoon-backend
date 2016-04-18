class ChatController < ApplicationController
  before_action :game, :airline

  @clients = []
  @conversations = {}

  EM.run do
    EM::WebSocket.start(host: ENV['WEBSOCKET_HOST'], port: ENV['WEBSOCKET_PORT']) do |ws|
      crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
      ws.onopen do |handshake|
        params = Rack::Utils.parse_nested_query(handshake.query_string)
        if((!params)||(!params["user_cookie"])||(!params["game_cookie"]))
          response = {
            error:"bad auth"
          }
        else
          user_data = {
            user_id:crypt.decrypt_and_verify(params["user_cookie"]),
            game_id:crypt.decrypt_and_verify(params["game_cookie"])
          }
          airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
          if airline
            alliance = airline.alliance
            game = airline.game
            client = {
              socket: ws,
              id: airline.id,
              alliance: (alliance ? alliance.id : nil),
              game: game.id,
              last_update: airline.last_update
            }
            @clients.push(client)
          end
        end
        ws.send '{"status":"opened"}'
      end

      ws.onclose do
        ws.send '{"status":"closed"}'
        client = @clients.find {|client| client[:socket] == ws }
        Airline.find(client[:id]).update(last_update: client[:last_update]) rescue nil
        @clients.delete client
        conversations = @conversations.find {|conversation| conversation[:airlines].include?(client.id) }
        if conversations
          conversations.each do |conversation|
            @conversations.delete conversation
          end
        end
      end

      ws.onmessage do |data|
        message_data = JSON.parse(data) rescue nil # parse the message json
        airline = @clients.select {|client| client[:socket] == ws }
        if message_data && (airline.size == 1) # only proceed if there is an airline found for this socket and message_data is json
          airline = airline[0]
          airline_data = {
            airline_id:airline[:id],
            game_id:airline[:game]
          }
          if ((airline_data[:airline_id] == nil)||(airline_data[:game_id] == nil))
            response = {
              error:"bad auth"
            }
          else
            msg_status = {status:'Error sending message'}
            airline = Airline.find(airline_data[:airline_id])
            type = message_data["message_type"]
            type_id = nil
            if type == "Alliance"
              type_id = (airline.alliance ? airline.alliance.id : nil) # if the airline is not in an alliance, then they cannot send a message to an alliance
            elsif type == "Airline"
              sender = airline.id
              recipient = message_data["type_id"]
              existing_conversation = @conversations.select {|id, conversation| (((conversation[:recipient] == sender)&&(conversation[:sender] == recipient))||((conversation[:sender] == sender)&&(conversation[:recipient] == recipient))) } # check if there is already an open conversation between the two (both airlines are connected to the websocket server)
              if existing_conversation.length > 0
                type_id = existing_conversation.first[0]
              else
                conversation = Conversation.find_by("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)", sender, recipient, recipient, sender) # check if the two airlines already have a conversation
                if conversation
                  type_id = conversation.id
                else
                  sender_airline = (Airline.find(sender) rescue nil) # confirm that both the sender and recipient exists
                  recipient_airline = (Airline.find(recipient) rescue nil)
                  if ((sender_airline)&&(recipient_airline)&&(sender_airline.game == recipient_airline.game)) # only proceed if they are both in the same game
                    new_conversation = Conversation.new(sender_id:sender_airline.id, recipient_id:recipient_airline.id) # create the new conversation between the two
                    if new_conversation.save
                      type_id = new_conversation.id
                    else
                      type_id = nil
                    end
                  else
                    type_id = nil
                  end
                end
              end
              airline_id = recipient # type id will be set to Conversation, so airline_id must be set so the message can be directed to that airline's socket
              type = "Conversation"
            elsif type == "Game"
              type_id = airline_data[:game_id]
            end
            if type_id != nil # don't bother trying to send a message if it doesn't have a type id
              body = message_data["body"]
              message = Message.new(body:body, airline_id:airline.id, message_type:type, type_id:type_id) # create the message in the database
              if message.save # only send it if it was saved
                if message.message_type == "Alliance"
                  alliance_airlines = @clients.select {|client| client[:alliance] == message.type_id } # get an array of all the airlines in the alliance with an open socket
                  if alliance_airlines.length > 0
                    alliance_airlines.each do |alliance_airline|
                      if alliance_airline[:id] != message.airline_id # don't send the message to sender
                        alliance_airline[:socket].send [message.serialize].to_json # and send them the message
                      end
                    end
                  end
                elsif message.message_type == "Game" # get an array of all the airlines in the game with an open socket
                  game_airlines = @clients.select {|client| client[:game] == message.type_id }
                  if game_airlines.length > 0
                    game_airlines.each do |game_airline|
                      if game_airline[:id] != message.airline_id # don't send the message to the sender
                        game_airline[:socket].send [message.serialize].to_json # but send it to everyone else
                      end
                    end
                  end
                elsif message.message_type == "Conversation"
                  recipient_airline = @clients.select {|client| client[:id] == airline_id } # find the recipient airline amongst the open sockets
                  if recipient_airline.length > 0 # if it is found
                    recipient_airline[0][:socket].send [message.serialize].to_json # send them the message
                  end
                end
                msg_status = {status:'Message sent'}
              end
            else
              msg_status = {status:'Message recipient not found'}
            end
          end
        end
      end
      # ws://localhost:3001?user_cookie=NThWZExFQlVoUzVubTNaVXN5SllQUT09LS0weTlCbEhYZ0tXMHkzQTFQR0l2cU1BPT0=--40387434903cf41f0385c5a1756ec1029f7da12c&game_cookie=L1N4aE9wZnlxT1puL0RWS3RpMWRDUT09LS1HdjdiMzVnd2E4WjQ1Q1NPT21vbVR3PT0=--d86d8807568aae3e57698e02b42d30b720bb754c
      # ws://localhost:3001?user_cookie=Y2ZKNE9TS3dERGE3RERtMlAwSE11Zz09LS1YVk4wSzY2M3BWd1hFSDJja3o4TkRRPT0=--575eb75ed9fb751c9ce6afbf21e91fae4b0778fa&game_cookie=L1N4aE9wZnlxT1puL0RWS3RpMWRDUT09LS1HdjdiMzVnd2E4WjQ1Q1NPT21vbVR3PT0=--d86d8807568aae3e57698e02b42d30b720bb754c
      # {"message_type":"Airline","type_id":37","body":"hey mang"}
      # return msg_status.to_json
    end

    timer = EventMachine::PeriodicTimer.new(5) do
      require 'notificationcenter'
      notification_center = NotificationCenter.new
      @clients.each do |client|
        notifications = notification_center.notifications(client[:id], client[:last_update])
        client[:last_update] = Time.now
        if notifications.size > 0
          client[:socket].send notifications.to_json
        end
      end
    end
  end

  def join
    render json: { server: 'started' }
  end

  def get_conversation_id sender, recipient
    existing_conversation = @conversations.select {|id, conversation| (((conversation[:recipient] == sender)&&(conversation[:sender] == recipient))||((conversation[:sender] == sender)&&(conversation[:recipient] == recipient))) }
    if existing_conversation.length > 0
      return existing_conversation.first[0]
    else
      conversation = Conversation.find_by("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)", sender, recipient, recipient, sender)
      if conversation
        return conversation.id
      else
        sender_airline = (Airline.find(sender) rescue nil)
        recipient_airline = (Airline.find(recipient) rescue nil)
        if ((sender_airline)&&(recipient_airline)&&(sender_airline.game == recipient_airline.game))
          new_conversation = Conversation.new(sender_id:sender_airline.id, recipient_id:recipient_airline.id)
          if new_conversation.save
            return new_conversation.id
          else
            return nil
          end
        else
          return nil
        end
      end
    end
  end

end
