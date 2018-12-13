Rails.application.routes.draw do
  root 'sprints#index'

  resources :users, :teams
  resources :tickets do
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
