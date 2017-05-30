Rails.application.routes.draw do
  root 'home#index'

  #devise_for :users, controllers: {registrations: "registrations"}




  devise_for :users, controllers: {registrations: "registrations"} do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end





  resources :records,only: [:show]
  resources :things,only: [:show]

  get 'page/query'
  get 'details' => 'page#details'







end
