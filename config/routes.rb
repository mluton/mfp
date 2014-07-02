Rails.application.routes.draw do

  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resources :articles, except: [:index]
  resources :categories
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  root 'categories#index'

end
