Rails.application.routes.draw do

  root 'app#index'

  post 'airlines' => 'airline#create'
  get 'airlines' => 'airline#all'


  post 'user/autologin' => 'user#autologin'
  post 'user/' => 'user#create'
  get 'user/manuallogin' => 'user#manuallogin'

  get 'alliances' => 'alliance#all'
  post 'alliances' => 'alliance#create'
  get 'alliances/:id' => 'alliance#show'
  delete 'alliances/:id' => 'alliance#delete'
  post 'alliances/:id/request/' => 'alliance#request_membership'
  post 'alliances/:id/approve/' => 'alliance#approve_membership'
  post 'alliances/:id/reject/' => 'alliance#reject_membership'


end
