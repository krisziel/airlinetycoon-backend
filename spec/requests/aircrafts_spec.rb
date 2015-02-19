require 'rails_helper'

describe 'user can fetch list of aircraft' do
  it 'can get aircraft list' do
    get '/aircrafts'
    aircraft = JSON.parse(response.body)

    boeing777 = aircraft[0]
    expect(boeing777['name']).to eq('777')
  end
end
