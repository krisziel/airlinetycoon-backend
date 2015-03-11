Rails.application.routes.draw do

  root 'app#index'

  get 'games' => 'game#all' # rspec passing
  get 'games/manuallogin' => 'game#manual_login' # rspec passing
  get 'games/:id' => 'game#show' # rspec passing

  post 'airlines' => 'airline#create' # rspec passing
  get 'airlines' => 'airline#all' # rspec passing

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
  get 'user/manuallogin' => 'user#manuallogin' # rspec passing

  get 'alliances' => 'alliance#all' # rspec passing
  post 'alliances' => 'alliance#create' # rspec passing
  get 'alliances/:id' => 'alliance#show' # rspec passing
  delete 'alliances/:id' => 'alliance#delete' # rspec passing
  post 'alliances/:id/request/' => 'alliance#request_membership' # rspec passing
  post 'alliances/:id/approve/' => 'alliance#approve_membership' # rspec passing
  post 'alliances/:id/reject/' => 'alliance#reject_membership' # rspec passing
  post 'alliances/:id/eject/' => 'alliance#end_membership' # rspec passing

  get 'chat/alliance' => 'alliance_chat#all' # rspec passing
  post 'chat/alliance' => 'alliance_chat#create' # rspec passing
  get 'chat/game' => 'game_chat#all' # rspec passing
  post 'chat/game' => 'game_chat#create' # rspec passing
  get 'chat/messages' => 'messages#all'
  post 'chat/messages' => 'messages#create'

  get 'airport' => 'airport#all' # rspec passing
  get 'airport/region/:region' => 'airport#all' # rspec passing
  get 'airport/city/:city' => 'airport#all' # rspec passing
  get 'airport/:icao' => 'airport#show' # rspec passing

  get 'route/:id' => 'route#show' #rspec passing

  get 'flight' => 'flight#all'
  get 'flight/airport/:iata' => 'flight#airport'
  get 'flight/aircraft/:iata' => 'flight#aircraft'
  get 'flight/:id' => 'flight#show'
  put 'flight/:id' => 'flight#update'
  post 'flight/:id' => 'flight#create'
  delete 'flight/:id' => 'flight#delete'

end
