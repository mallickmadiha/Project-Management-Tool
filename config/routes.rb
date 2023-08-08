# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'
  post '/signin', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users, only: %i[edit update destroy]
  resources :users, param: :username, only: [:show]

  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'auth/failure', to: redirect('/')

  resources :chats, only: %i[create]
  get '/chats/new', to: 'chats#new'

  resources :projects do
    post 'update_user_ids', on: :collection
    get '/adduser', to: 'projects#adduser'

    resources :details do
      post 'update_user_ids', on: :member
      resources :tasks do
      end
    end
  end

  post '/change_status/:id', to: 'details#change_status'
  get 'search_items', to: 'details#feature_search', as: 'search_items'
  post '/search/:id', to: 'search#search', as: 'search'
  post '/notifications/mark_read', to: 'notifications#mark_read'
  get '*unmatched', to: 'application#page_not_found'
end
