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
        message_data = JSON.parse(data) rescue nil
        if message_data
          user_id = message_data["user_id"] ? message_data["user_id"] : ""
          game_id = message_data["game_id"] ? message_data["game_id"] : ""
          user_data = {
            user_id:(crypt.decrypt_and_verify(user_id) rescue nil),
            game_id:(crypt.decrypt_and_verify(game_id) rescue nil)
          }
          puts user_data
          if ((user_data[:user_id] == nil)||(user_data[:game_id] == nil))
            response = {
              error:"bad auth"
            }
          else
            msg_status = {status:'Error sending message'}
            airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
            type = message_data["message_type"]
            type_id = nil
            if type == "Alliance"
              type_id = (airline.alliance ? airline.alliance.id : nil)
            elsif type == "Airline"
              # type_id = get_conversation_id airline.id, type_id
              airline = (Game.find(user_data[:game_id]).airlines.find(message_data["type_id"]).id rescue nil)
            elsif type == "Game"
              type_id = user_data[:game_id]
            end
            if type_id != nil
              body = message_data["body"]
              message = Message.new(body:body, airline_id:airline.id, message_type:type, type_id:type_id)
              if message.save
                if message.message_type == "Alliance"
                  alliance_airlines = @clients.select {|client| client[:alliance] == message.type_id }
                  if alliance_airlines.length > 0
                    alliance_airlines.each do |alliance_airline|
                      alliance_airline[:socket].send message.serialize
                    end
                  end
                elsif message.message_type == "Game"
                  game_airlines = @clients.select {|client| client[:game] == message.type_id }
                  if game_airlines.length > 0
                    game_airlines.each do |game_airline|
                      if game_airline[:id] != message.airline_id
                        game_airline[:socket].send message.serialize.to_json
                      end
                    end
                  end
                elsif message.message_type == "Airline"
                  recipient_airline = @clients.select {|client| client[:id] == type_id }
                  if recipient_airline.length > 0
                    recipient_airline[0][:socket].send message.serialize.to_json
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
      return msg_status.to_json
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

  def send_message message_data, user_data
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

  # def test
  #   airlines = [27, 36, 37, 28, 30, 33, 40, 31, 38, 35, 39, 26, 32, 34, 29]
  #   start = Time.now
  #   10000.times do |i|
  #     sender = airlines.sample
  #     recipient = airlines.sample
  #     conversation = get_conversation_id sender, recipient
  #   end
  #   finish = Time.now
  #   puts "TOOK #{(finish - start)} SECONDS"
  # end
  #
  # def test2
  #   airlines = [27, 36, 37, 28, 30, 33, 40, 31, 38, 35, 39, 26, 32, 34, 29]
  #   start = Time.now
  #   500.times do |i|
  #     @conversations[i] = {
  #       sender:airlines.sample,
  #       recipient:airlines.sample
  #     }
  #   end
  #   10000.times do |i|
  #     s = airlines.sample
  #     r = airlines.sample
  #     convo = @conversations.select {|id, conversation| (((conversation[:recipient] == s)&&(conversation[:sender] == r))||((conversation[:sender] == s)&&(conversation[:recipient] == r))) }
  #     @conversations.each do |id, conversation|
  #       puts conversation[:recipient]
  #       puts "#{conversation[:recipient]} - #{s} // #{conversation[:sender]} - #{r}"
  #       a = (conversation[:recipient] == s)
  #       b = (conversation[:recipient] == r)
  #       c = (conversation[:sender] == s)
  #       d = (conversation[:sender] == r)
  #       puts "#{a} - #{b} - #{c} - #{d}"
  #       if ((a&&d)||(b&&c))
  #         break
  #       end
  #     end
  #   end
  #   finish = Time.now
  #   puts "TOOK #{(finish - start)} SECONDS"
  # end

end
