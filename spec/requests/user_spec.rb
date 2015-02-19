require 'rails_helper'

describe 'airline request#' do
  it 'expects a 200 response with error json' do
    post '/user/autologin'
  end
end
