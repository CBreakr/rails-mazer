Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :mazes, except: [:new, :edit]
  resources :journeys, only: [:index, :show, :create, :destroy]

  # what about for the Journey model?

  root "application#welcome"

  get '/login', to: 'sessions#new', as: "login"
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy', as: "logout"

  post "/journeys/:id/:move", to: "journeys#move", as: "move"
end
