class ChatController < ApplicationController
  before_action :game, :airline

  @clients = {
    alliance:{},
    game:{},
    conversation:{}
  }
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
        client = {socket: ws}
        alliance = airline.alliance
        game = airline.game
        if alliance
          if @clients[:alliance][alliance.id]
            @clients[:alliance][alliance.id].push(client)
          else
            @clients[:alliance][alliance.id] = [client]
          end
        end
        if @clients[:game][game.id]
          @clients[:game][game.id].push(client)
        else
          @clients[:game][game.id] = [client]
        end
        ws.send "hello"
      end

      ws.onclose do
        ws.send "Closed."
        @clients.delete ws
      end

      ws.onmessage do |data|
        data = data.split("lIlIlIIlIlIl")
        params = Rack::Utils.parse_nested_query(data[-1])
        user_data = {
          user_id:crypt.decrypt_and_verify(params["user_cookie"]),
          game_id:crypt.decrypt_and_verify(params["?game_cookie"])
        }
        airline = Airline.find_by(user_id:user_data[:user_id],game_id:user_data[:game_id])
        message_data = JSON.parse(data[0])
        type_id = message_data["type_id"]
        message_type = message_data["message_type"]
        body = message_data["body"]
        if message_permissions(airline, message_data)
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
        else
          
        end
      end
    end
  end

  def join
    render json: {error:'nothing'}
  end

end
