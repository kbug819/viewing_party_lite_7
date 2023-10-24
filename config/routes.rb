# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'welcome#index'
  get '/register', to: 'users#new'
  # resources :register, only: [], controller: "users#new"
  resources :users, only: %i[show create] do
    resources :movies, only: %i[index show], controller: 'users/movies' do
      resources :viewing_parties, only: %i[new create], controller: 'users/movies/viewing_parties'
    end
  end

  get '/users/:id/discover', to: 'users/discover#index'
  get '/login', to: "users#login_form"
  post '/login', to: "users#login_user"
end
