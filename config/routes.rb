Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"
  
  get '/' => 'dashboard#show', :constraints => { :subdomain => /.+/ }
  root 'static_pages#show'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks'
  }

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
