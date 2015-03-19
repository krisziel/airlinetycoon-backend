require 'rails_helper'

describe 'airtycoon API -- messages#' do

  before do
    get 'user/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    get 'games/manuallogin'
    Airline.create(name:"INnoVation Airlines",icao:"INO",user_id:1,game_id:1,money:500)
    Airline.create(name:"Maru Airways",icao:"MRU",user_id:2,game_id:1,money:500)
    Airline.create(name:"SKT Airline",icao:"SKT",user_id:3,game_id:1,money:500)
    Airline.create(name:"Airai-Castlegar",icao:"ROR",user_id:3,game_id:1,money:500)
  end

  it 'can receive a list of all conversations' do
    Conversation.create(sender_id:1,recipient_id:2)
    Conversation.create(sender_id:3,recipient_id:1)
    get 'chat/conversation'
    conversations = JSON.parse(response.body)
    expect(conversations[1]["sender"]["name"]).to eq("SKT Airline")
  end

  it 'can create a new conversation' do
    post 'chat/conversation',
    {
      conversation:{
        recipient_id:2
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["recipient"]["name"]).to eq("Maru Airways")
  end

  it 'cannot access a conversation of another user' do
    Conversation.create(sender_id:3,recipient_id:2)
    get 'chat/conversation/1'
    conversation = JSON.parse(response.body)
    expect(conversation["error"]).to eq("conversation does not belong to user")
  end

  it 'returns the existing conversation if conversation combo already exists' do
    Conversation.create(sender_id:1,recipient_id:2)
    post 'chat/conversation',
    {
      conversation:{
        recipient_id:2
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["status"]).to eq("conversation already exists")
  end

  it 'can receive messages from a specific user' do
    conv = Conversation.new(sender_id:3,recipient_id:1)
    conv.save
    conv.messages.create(airline_id:1,body:"hello")
    conv.messages.create(airline_id:3,body:"hi")
    conv.messages.create(airline_id:3,body:"how are you?")
    get 'chat/conversation/1'
    conversation = JSON.parse(response.body)
    expect(conversation[0]["body"]).to eq("how are you?")
  end

  it 'can receive messages since a given time' do
    conv = Conversation.new(sender_id:3,recipient_id:1)
    conv.save
    conv.messages.create(airline_id:1,body:"hello")
    conv.messages.create(airline_id:3,body:"hi")
    conv.messages.create(airline_id:3,body:"how are you?")
    sleep 1
    timestamp = Time.new.to_i
    sleep 1
    conv.messages.create(airline_id:1,body:"doing just fine, hbu")
    conv.messages.create(airline_id:3,body:"just chillin")
    get 'chat/conversation/1',
    {
      since: timestamp
    }
    conversation = JSON.parse(response.body)
    expect(conversation[0]["body"]).to eq("just chillin")
    expect(conversation.length).to eq(2)
  end

  it 'can load messages with offset' do
    conv = Conversation.new(sender_id:3,recipient_id:1)
    conv.save
    conv.messages.create(airline_id:1,body:"hello")
    conv.messages.create(airline_id:3,body:"hi")
    conv.messages.create(airline_id:3,body:"how are you?")
    conv.messages.create(airline_id:1,body:"doing just fine, hbu")
    conv.messages.create(airline_id:3,body:"just chillin")
    get 'chat/conversation/1',
    {
      offset: 3
    }
    conversation = JSON.parse(response.body)
    expect(conversation[0]["body"]).to eq("just chillin")
    expect(conversation.length).to eq(2)
  end

  it 'cannot send duplicate messages within fifteen seconds' do
    conv = Conversation.new(sender_id:3,recipient_id:1)
    conv.save
    conv.messages.create(airline_id:1,body:"hello")
    post 'chat/conversation/1/message',
    {
      message:{
        body:'hello'
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["error"]).to eq("duplicate message")
  end

  it 'cannot send an empty message' do
    conv = Conversation.new(sender_id:3,recipient_id:1)
    conv.save
    post 'chat/conversation/1/message',
    {
      message:{
        body:''
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["error"]).to eq("empty message")
  end

  it 'can send a message' do
    conv = Conversation.new(sender_id:1,recipient_id:4)
    conv.save
    post 'chat/conversation/1/message',
    {
      message:{
        body:'sup bae'
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["body"]).to eq("sup bae")
  end

  it 'can send multiple non-duplicate messages' do
    conv = Conversation.new(sender_id:1,recipient_id:4)
    conv.save
    post 'chat/conversation/1/message',
    {
      message:{
        body:'sup bae'
      }
    }
    conv.messages.new(airline_id:4,body:'hey there')
    post 'chat/conversation/1/message',
    {
      message:{
        body:'whats happenin'
      }
    }
    conversation = JSON.parse(response.body)
    expect(conversation["body"]).to eq("whats happenin")
  end

end
