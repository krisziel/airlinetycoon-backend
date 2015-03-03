require 'rails_helper'

describe 'user#' do

  user_data = {name:"Kris",username:"kziel",password:"kziel"}

  it 'is able to create a user' do
    user = User.create!(user_data)
    expect(user.name).to eq("Kris")
  end

  it 'is unable to create a userwith without name, username, and password' do
    expect(User.create({name:"",username:"",password:""}).errors.messages.length).to eq(3)
  end

  it 'can create an airline for a user' do
    user = User.create!(user_data)
    airline = user.airlines.create!({name:"INnoVation Airlines",icao:"INO",money:500000000,game_id:1})
    expect(airline.name).to eq("INnoVation Airlines")
  end

end
