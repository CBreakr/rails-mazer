Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :mazes
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "application#welcome"

  get '/login' => 'sessions#new', as: "login"
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy', as: "logout"
end
