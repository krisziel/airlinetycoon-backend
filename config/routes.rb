Rails.application.routes.draw do

  root 'app#index'

  post 'airline/create' => 'airline#create'
  post 'user/autologin' => 'user#autologin'
  get 'user/manuallogin' => 'user#manuallogin'

  resources :aircrafts

end
