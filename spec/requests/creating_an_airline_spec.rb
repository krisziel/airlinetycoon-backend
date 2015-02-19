require 'rails_helper'

describe 'the airlinetycoon API' do
  it 'allows a new user to create an airline' do

    post '/airline/create',
    {
      'airline[name]' => 'INnoVation Airlines',
      'airline[iata]' => 'INO'
    }

    airline = JSON.parse(response.body)
    expect(airline['name']).to eq('INnoVation Airlines')
  end
end
