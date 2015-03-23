require 'rails_helper'

describe 'airtycoon API -- alliance chat#' do
  before do
    get 'user/manuallogin'
    get 'games/manuallogin'
    Game.create(region:'all',year:'2Q2015')
    Airline.create(name:"INnoVation Airlines", icao:"INO", money:500000000, game_id:1, user_id:1)
    Airline.create(name:"Velocity Air Germany", icao:"CRG", money:500000000, game_id:1, user_id:2)
    Alliance.create(name:"Star Alliance", game_id:1)
    AllianceMembership.create(airline_id:1, alliance_id:1)
  end

  it 'can read all messages (gets the number of messages)' do
    AllianceChat.create(airline_id:1,alliance_id:1,message:'this is a message')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'this is another message')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'well that is so kind of you to reply')
    get 'chat/alliance'
    message = JSON.parse(response.body)
    expect(message.length).to eq(3)
  end

  it 'can read all messages (gets the first message)' do
    AllianceChat.create(airline_id:1,alliance_id:1,message:'this is a message')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'this is another message')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'well that is so kind of you to reply')
    get 'chat/alliance'
    message = JSON.parse(response.body)
    expect(message[2]["message"]).to eq('well that is so kind of you to reply')
  end

  it 'can read messages offset' do
    AllianceChat.create(airline_id:1,alliance_id:1,message:'this is a message')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'this is another message')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'well that is so kind of you to reply')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'pls reply')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'okay')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'I have replied')
    get 'chat/alliance',
    {
      offset: 4
    }
    message = JSON.parse(response.body)
    expect(message[1]["message"]).to eq('I have replied')
  end

  it 'can read messages since specific time' do
    AllianceChat.create(airline_id:1,alliance_id:1,message:'this is a message')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'this is another message')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'well that is so kind of you to reply')
    sleep 1
    timestamp = Time.new.to_i
    sleep 1
    AllianceChat.create(airline_id:1,alliance_id:1,message:'pls reply')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'okay')
    get 'chat/alliance',
    {
      since:timestamp
    }
    message = JSON.parse(response.body)
    expect(message.length).to eq(2)
  end

  it 'can request a specific number of messages' do
    AllianceChat.create(airline_id:1,alliance_id:1,message:'this is a message')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'this is another message')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'well that is so kind of you to reply')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'pls reply')
    AllianceChat.create(airline_id:2,alliance_id:1,message:'okay')
    AllianceChat.create(airline_id:1,alliance_id:1,message:'I have replied')
    get 'chat/alliance',
    {
      offset: 4,
      limit: 2
    }
    message = JSON.parse(response.body)
    expect(message.length).to eq(2)
  end

  it 'can send message (returns proper airline)' do
    post 'chat/alliance',
    {
      alliance_chat:{
        message:'Welcome all to the Star'
      }
    }
    message = JSON.parse(response.body)
    expect(message["airline"]["name"]).to eq('INnoVation Airlines')
  end

  it 'can send message (returns proper message)' do
    post 'chat/alliance',
    {
      alliance_chat:{
        message:'Welcome all to the Star'
      }
    }
    message = JSON.parse(response.body)
    expect(message["message"]).to eq('Welcome all to the Star')
  end

end
