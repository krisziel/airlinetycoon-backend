class ChatController < ApplicationController
  before_action :game, :airline

  @clients = []
  @conversations = []

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
          if ((user_data[:user_id] == nil)||(user_data[:game_id] == nil))
            response = {
              error:"bad auth"
            }
          else
            airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
            type_id = message_data["type_id"]
            type = message_data["message_type"]
            body = message_data["body"]
            message = Message.new(body:body, airline_id:airline.id, message_type:type, type_id:type_id)
            if message.save
              if message.message_type == "alliance"
                alliance_airlines = @clients.select {|client| client[:alliance] == message.type_id }
                if alliance_airlines
                  alliance_airlines.each do |alliance_airline|
                    alliance_airline[:socket].send message.serialize
                  end
                end
              elsif message.message_type == "game"
                game_airlines = @clients.select {|client| client[:game] == message.type_id }
                if game_airlines
                  game_airlines.each do |game_airline|
                    if game_airline[:id] != message.airline_id
                      game_airline[:socket].send message.serialize.to_json
                    end
                  end
                end
              elsif message.message_type == "conversation"
              end
            end
          end
        end
      end

      def send_message message
        if message.message_type == "alliance"
          alliance_airlines = @clients.find {|client| client[:alliance] == message.type_id }
          if alliance_airlines
            alliance_airlines.each do |alliance_airline|
              alliance_airline[:socket].send message.serialize
            end
          end
        elsif message.message_type == "game"
          game_airlines = @clients.find {|client| client[:game] == message.type_id }
          if game_airlines
            game_airlines.each do |game_airline|
              game_airline[:socket].send message.serialize
            end
          end
        elsif message.message_type == "conversation"
        end
      end
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

end
