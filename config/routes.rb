Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'sprints#index'

  resources :users, only: [:index, :show, :edit, :update]
  resources :tickets, except: [:new, :create] 
  resources :teams, except: [:destroy]

  namespace :webhooks do
    resources :members, only: :create
    resources :issues, only: :create
  end
  
  resources :sprints do
    member do
      get 'manage'
    end
  end
end
