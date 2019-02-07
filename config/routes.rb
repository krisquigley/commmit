Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'sprints#index'

  resources :users, :teams
  resources :tickets, except: [:new] do
    member do
      get 'manage'
    end
  end
  
  resources :sprints do
    member do
      get 'manage'
    end
  end
end
