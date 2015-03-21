Rails.application.routes.draw do

  get 'game' => 'game#all' # rspec passing
  get 'games/manuallogin' => 'game#manual_login' # rspec cookie workaround
  get 'game/:id' => 'game#show' # rspec passing

  post 'airline' => 'airline#create' # rspec passing
  get 'airline' => 'airline#all' # rspec passing

  get 'aircraft' => 'aircraft#all' # rspec passing
  get 'aircraft/seats' => 'aircraft#seats' # rspec passing
  get 'aircraft/user' => 'user_aircraft#all' # rspec passing
  post 'aircraft/user' => 'user_aircraft#create' # rspec passing
  put 'aircraft/user' => 'user_aircraft#update' # rspec passing
  delete 'aircraft/user' => 'user_aircraft#delete' # not sure about need

  get 'aircraft/configs' => 'configuration#all' # rspec passing
  get 'aircraft/configs/:type' => 'configuration#type' # rspec passing
  post 'aircraft/configs' => 'configuration#create' # rspec passing
  delete 'aircraft/configs/:id' => 'configuration#delete' # rspec passing

  post 'user/autologin' => 'user#autologin' # rspec passing
  post 'user/' => 'user#create' # rspec passing
  post 'user/login' => 'user#login'
  get 'user/manuallogin' => 'user#manuallogin' # rspec passing

  get 'alliance' => 'alliance#all' # rspec passing
  post 'alliance' => 'alliance#create' # rspec passing
  get 'alliance/:id' => 'alliance#show' # rspec passing
  delete 'alliance/:id' => 'alliance#delete' # rspec passing
  post 'alliance/:id/request' => 'alliance#request_membership' # rspec passing
  post 'alliance/:id/approve' => 'alliance#approve_membership' # rspec passing
  post 'alliance/:id/reject' => 'alliance#reject_membership' # rspec passing
  post 'alliance/:id/eject' => 'alliance#end_membership' # rspec passing

  get 'chat/alliance' => 'alliance_chat#all' # rspec passing
  post 'chat/alliance' => 'alliance_chat#create' # rspec passing
  get 'chat/game' => 'game_chat#all' # rspec passing
  post 'chat/game' => 'game_chat#create' # rspec passing
  get 'chat/conversation' => 'conversation#all' # rspec passing
  post 'chat/conversation' => 'conversation#create' # rspec passing
  get 'chat/conversation/:id' => 'conversation#show' # rspec passing
  post 'chat/conversation/:id/message' => 'message#create' # rspec passing

  get 'airport' => 'airport#all' # rspec passing
  get 'airport/region/:region' => 'airport#all' # rspec passing
  get 'airport/city/:city' => 'airport#all' # rspec passing
  get 'airport/:icao' => 'airport#show' # rspec passing

  get 'route/:id' => 'route#show' # rspec passing

  get 'flight' => 'flight#all' # rspec passing
  get 'flight/aircraft/:iata' => 'flight#aircraft' # rspec passing
  get 'flight/:id' => 'flight#show' # rspec passing
  put 'flight/:id' => 'flight#update' # rspec passing
  post 'flight/' => 'flight#create' # rspec passing
  delete 'flight/:id' => 'flight#delete' # rspec passing

end
