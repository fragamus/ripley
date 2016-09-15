Rails.application.routes.draw do
  resources :records,only: [:show]
  resources :things,only: [:show]

  root 'page#query'
  get 'details' => 'page#details'
end
