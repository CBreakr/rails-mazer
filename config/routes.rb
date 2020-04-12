Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :mazes, except: [:new, :edit]
  resources :journeys, only: [:index, :show, :create, :destroy]

  # what about for the Journey model?

  root "mazes#index"

  get '/login', to: 'sessions#new', as: "login"
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy', as: "logout"

  post "/journeys/:id/:move", to: "journeys#move", as: "move"

  post "/mazes/:id/check_solve", to: "mazes#check_solve", as: "check_solve"
  post "/mazes/:id/check_step", to: "mazes#check_step", as: "check_step"
  post "/mazes/:id/reset", to: "mazes#reset", as: "reset"

  match '*path' => redirect('/'), via: :get
end
