Rails.application.routes.draw do
  root 'sprints#index'

  resources :users, :teams, :tickets
  
  resources :sprints do
    member do
      get 'manage'
    end
  end
end
