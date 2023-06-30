# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  get '/signup', to: 'users#new'

  post '/signup', to: 'users#create'

  post '/signin', to: 'sessions#create'

  get '/', to: 'sessions#new'

  resources :sessions, only: [:destroy]

  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'

  get '/username_fetch', to: 'users#username_fetch'

  # Routes for Google authentication
  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'auth/failure', to: redirect('/')

  resources :chats, only: %i[new create]

  get '/room', to: 'room#index'

  # post "/chats", to: "chats#create"
  # get "/chats", to: "chats#index"

  get '/chats/new', to: 'chats#new'
  get '/chats/last_message', to: 'chats#last_message'

  resources :projects do
    resources :details
  end
end
