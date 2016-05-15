Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match "/test", to: "application#test", via: "get"

  resources :users , only: [:create, :update, :destroy, :show, :index]
  resources :games , only: [:create, :update, :destroy, :show, :index] do
    resources :clues , only: [:create, :update, :destroy, :show, :index]
  end

  match "/login", to: "users#login", via: "post"
  match "/games/:id/join", to: "games#join", via: "patch"
  put '/games/:id/join', to: 'games#join'
  
  get "/games/:id/players", to: 'games#players'
  get "/users/:id/games", to: 'users#games'
  get "/users/:id/created_games", to: 'users#created_games'

  match "/games/:id/quit", to: "games#quit", via: "delete"
  match "/users/register_token", to: "users#register_token", via: "post"

  match "/games/:id/clues/:clue_id/discover", to: "games#discover", via: "patch"
  put '/games/:id/clues/:clue_id/discover', to: 'games#discover'

  get '/games/:id/score_board', to: 'games#score_board'
  get '/users/:id/tokens', to: 'users#tokens'
end
