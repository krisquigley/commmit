Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'sprints#index'

  resources :users, only: [:index, :show, :edit, :update]

  namespace :webhooks do
    resources :members, only: :create
    resources :issues, only: :create
  end
  
  resources :sprints do
    resources :sprint_tickets
    member do
      get 'manage'
      delete 'close'
    end
  end
end
