Rails.application.routes.draw do

  root 'app#index'

  post 'airline/create' => 'airline#create'
  get 'airline/all' => 'airline#all'
  post 'user/autologin' => 'user#autologin'
  post 'user/create' => 'user#create'
  get 'user/manuallogin' => 'user#manuallogin'

  resources :aircrafts

end
