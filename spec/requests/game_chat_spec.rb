require 'rails_helper'

describe 'airtycoon API -- game_chat#' do
  before do
    get 'user/manuallogin'
    get 'games/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    Airline.create(name:"INnoVation Airlines", icao:"INO", money:500000000, game_id:1, user_id:1)
    Airline.create(name:"Velocity Air Germany", icao:"CRG", money:500000000, game_id:1, user_id:2)
  end

  it 'can read all messages (gets the number of messages)' do
    GameChat.create(airline_id:1,game_id:1,message:'this is a message')
    GameChat.create(airline_id:2,game_id:1,message:'this is another message')
    GameChat.create(airline_id:1,game_id:1,message:'well that is so kind of you to reply')
    get 'chat/game'
    message = JSON.parse(response.body)
    expect(message.length).to eq(3)
  end

  it 'can read all messages (gets the first message)' do
    GameChat.create(airline_id:1,game_id:1,message:'this is a message')
    GameChat.create(airline_id:2,game_id:1,message:'this is another message')
    GameChat.create(airline_id:1,game_id:1,message:'well that is so kind of you to reply')
    get 'chat/game'
    message = JSON.parse(response.body)
    expect(message[2]["message"]).to eq('well that is so kind of you to reply')
  end

  it 'can read messages offset' do
    GameChat.create(airline_id:1,game_id:1,message:'this is a message')
    GameChat.create(airline_id:2,game_id:1,message:'this is another message')
    GameChat.create(airline_id:1,game_id:1,message:'well that is so kind of you to reply')
    GameChat.create(airline_id:1,game_id:1,message:'pls reply')
    GameChat.create(airline_id:2,game_id:1,message:'okay')
    GameChat.create(airline_id:1,game_id:1,message:'I have replied')
    get 'chat/game',
    {
      offset: 4
    }
    message = JSON.parse(response.body)
    expect(message[1]["message"]).to eq('I have replied')
    expect(message.length).to eq(2)
  end

  it 'can read messages since specific time' do
    GameChat.create(airline_id:1,game_id:1,message:'this is a message')
    GameChat.create(airline_id:2,game_id:1,message:'this is another message')
    GameChat.create(airline_id:1,game_id:1,message:'well that is so kind of you to reply')
    sleep 1
    timestamp = Time.new.to_i
    sleep 1
    GameChat.create(airline_id:1,game_id:1,message:'pls reply')
    GameChat.create(airline_id:2,game_id:1,message:'okay')
    get 'chat/game',
    {
      since:timestamp
    }
    message = JSON.parse(response.body)
    expect(message.length).to eq(2)
  end

  it 'can request a specific number of messages' do
    GameChat.create(airline_id:1,game_id:1,message:'this is a message')
    GameChat.create(airline_id:2,game_id:1,message:'this is another message')
    GameChat.create(airline_id:1,game_id:1,message:'well that is so kind of you to reply')
    GameChat.create(airline_id:1,game_id:1,message:'pls reply')
    GameChat.create(airline_id:2,game_id:1,message:'okay')
    GameChat.create(airline_id:1,game_id:1,message:'I have replied')
    get 'chat/game',
    {
      offset: 4,
      limit: 2
    }
    message = JSON.parse(response.body)
    expect(message.length).to eq(2)
  end

  it 'can send message (returns proper airline)' do
    post 'chat/game',
    {
      game_chat:{
        message:'Welcome all to the Star'
      }
    }
    message = JSON.parse(response.body)
    expect(message["airline"]["name"]).to eq('INnoVation Airlines')
    expect(message["message"]).to eq('Welcome all to the Star')
  end

end
