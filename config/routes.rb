Rails.application.routes.draw do
  root 'sprints#index'

  resources :sprints, :users, :teams, :tickets
end
