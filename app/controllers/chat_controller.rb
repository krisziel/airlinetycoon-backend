class ChatController < ApplicationController
  before_action :game, :airline

  @clients = []
  @conversations = []
  EM.run do
    EM::WebSocket.start(host: ENV['WEBSOCKET_HOST'], port: ENV['WEBSOCKET_PORT']) do |ws|
      crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
      ws.onopen do |handshake|
        params = Rack::Utils.parse_nested_query(handshake.query_string)
        user_data = {
          user_id:crypt.decrypt_and_verify(params["user_cookie"]),
          game_id:crypt.decrypt_and_verify(params["game_cookie"])
        }
        airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
        alliance = airline.alliance
        game = airline.game
        client = {
          socket: ws,
          id: airline.id,
          alliance: alliance.id,
          game: game.id
        }
        @clients.push(client)
      end

      ws.onclose do
        ws.send '{"status":"closed"}'
        client = @clients.find {|client| client["socket"] == ws }
        @clients.delete client
        conversations = @conversations.find {|conversation| conversation["airlines"].include?(client.id) }
        conversations.each do |conversation|
          @conversations.delete conversation
        end
      end

      ws.onmessage do |data|
        data = data.split("lIlIlIIlIlIl")
        data[-1] = data[-1].gsub(/\?/,'')
        params = Rack::Utils.parse_nested_query(data[-1])
        user_data = {
          user_id:crypt.decrypt_and_verify(params["user_cookie"]),
          game_id:crypt.decrypt_and_verify(params["game_cookie"])
        }
        airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
        message_data = JSON.parse(data[0])
        type_id = message_data["type_id"]
        message_type = message_data["message_type"]
        body = message_data["body"]
        if airline.alliance.id == message_data["type_id"].to_i
          date = Time.now-15
          date = date.to_datetime
          dupe = Message.find_by('created_at > ? AND body=? AND type_id=?', date, body, type_id)
          if dupe
          else
            new_message = Message.new(body:body, airline_id:airline.id, message_type:message_type, type_id:type_id)
            if new_message.save
              recipients = @clients[message_type.to_sym][type_id.to_i]
              recipients.each do |socket|
                socket[:socket].send new_message.serialize.to_json
              end
            else
              if socket[:conv_info][:user_id] == conversation[:user_id]
                socket[:socket].send new_message.errors.to_json
              end
            end
          end
        else

        end
      end
    end
  end

  def join
    render json: {error:'nothing'}
  end

  private
  def message_permissions(airline,message_data)
    if message_data["message_type"] == "alliance"
      if airline.alliance.id == message_data["type_id"]
        true
      else
        false
      end
    else
      false
    end
  end

end
