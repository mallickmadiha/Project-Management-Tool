# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'sessions#new'
  post '/signin', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  resources :sessions, only: [:destroy]

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/username_fetch', to: 'users#username_fetch'

  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'auth/failure', to: redirect('/')

  resources :chats, only: %i[new create]
  get '/chats/new', to: 'chats#new'
  get '/chats/last_message', to: 'chats#last_message'

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
  post 'add_project_user', to: 'projects#add_project_user'

  post '/search/:id', to: 'search#search', as: 'search'
  post '/notifications/mark_read', to: 'notifications#mark_read'

  get 'search_items', to: 'details#elastic_search', as: 'search_items'
end
# rubocop:enable Metrics/BlockLength
