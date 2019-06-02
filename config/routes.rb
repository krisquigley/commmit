Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'dashboard#show'

  resources :users, only: [:index, :show, :edit, :update]

  namespace :webhooks do
    resources :members, only: :create
    resources :issues, only: :create
  end

  resource :dashboard, only: :show
  
  resources :sprints do
    resources :sprint_tickets
    resource :retrospective, only: [:new, :create, :show]
    member do
      get 'manage'
      delete 'close'
    end
  end
end
