Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'teams#index'

  resources :users, only: [:index, :show]

  namespace :webhooks do
    resources :members, only: :create
    resources :issues, only: :create
  end

  resource :dashboard

  resources :teams, only: [:index, :new, :create, :show], shallow: true do
    resources :sprints, only: [:new, :create, :show, :update], shallow: true do
      resources :sprint_tickets, only: [:create, :update, :destroy]
      resource :retrospective, only: [:new, :create, :show]
      member do
        post 'export_csv'
        get 'download_csv'
        get 'manage'
        delete 'close'
      end
    end
  end

  namespace :admin do
    root 'accounts#index'

    resources :accounts, only: [:index, :new, :create]
  end
end
