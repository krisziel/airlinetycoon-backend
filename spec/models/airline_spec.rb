require 'rails_helper'

describe Airline do

  it 'can create an airline' do
    Airline.create!(name:"Maru Airways",icao:"MRU",game_id:1,user_id:2,money:3)
    airline = Airline.new(name:"Maru Airways",icao:"MAR",game_id:1,user_id:2,money:3)
    airline.valid?
    expect(airline.errors[:name].size).to eq(1)
  end

end
