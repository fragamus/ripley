Rails.application.routes.draw do
  resources :photos
  resources :things, only: [:show]
end
