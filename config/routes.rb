Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'departments#index'

  resources :users, only: [:index, :show]

  namespace :webhooks do
    resources :members, only: :create
    resources :issues, only: :create
  end

  resources :departments, except: [:update, :edit, :destroy] do
    resources :teams, only: [:new, :create, :show], shallow: true do
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
  end
end
