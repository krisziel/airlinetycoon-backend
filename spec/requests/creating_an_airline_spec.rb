require 'rails_helper'

describe 'the airlinetycoon API' do
  it 'allows a new user to create an airline' do

    post '/airline/create',
    {
      'airline[name]' => 'My Cool Airline',
      'airline[iata]' => 'MCA'
    }

    airline = JSON.parse(response.body)
    expect(airline['name']).to eq('My Cool Airline')
  end
end
