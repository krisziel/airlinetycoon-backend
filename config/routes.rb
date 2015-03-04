Rails.application.routes.draw do

  root 'app#index'

  get 'games' => 'game#all'
  get 'games/manuallogin' => 'game#manual_login'
  get 'games/:id' => 'game#show'

  post 'airlines' => 'airline#create' # rspec passing
  get 'airlines' => 'airline#all' # rspec passing

  get 'aircraft' => 'aircraft#all' # rspec passing
  get 'aircraft/seats' => 'aircraft#seats' # rspec passing
  get 'aircraft/user/:id' => 'user_aircraft#all' # rspec pending seat/config
  post 'aircraft/user/:id' => 'user_aircraft#create'
  put 'aircraft/user/:id' => 'user_aircraft#update'
  delete 'aircraft/user/:id' => 'user_aircraft#delete'
  get 'aircraft/user/:id/configs' => 'configuration#all' # rspec in progress
  get 'aircraft/user/:id/configs/:type' => 'configuration#type'
  post 'aircraft/user/:id/configs' => 'configuration#create'
  delete 'aircraft/user/:id/configs' => 'configuration#delete'

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


end
