# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      # - (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils
        .secure_compare(::Digest::SHA256.hexdigest(username),
                        ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME'))) &
        ActiveSupport::SecurityUtils
        .secure_compare(::Digest::SHA256.hexdigest(password),
                        ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD')))
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'
  mount ActionCable.server => '/cable'

  get '/',  to: 'planned_stories#index',
            commmit_id: 'current',
            constraints: {
              subdomain: /.+/
            },
            as: :logged_in

  root 'static_pages#show'

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
    get 'signup', to: 'users/registrations#new'
  end

  devise_for  :users,
              controllers: {
                registrations: 'users/registrations',
                sessions: 'users/sessions',
                confirmations: 'users/confirmations',
                passwords: 'users/passwords',
                unlocks: 'users/unlocks',
                invitations: 'users/invitations'
              }

  resource :overview, only: :show
  resources :commmits, except: :show do
    resource :reflection, shallow: true
    resources :planned_stories, only: %i[show index create destroy] do
      patch :mark_as_done
      patch :mark_as_not_done
    end

    get :add_one_off_stories, to: 'planned_stories#add_one_off_stories'
    get :add_repeatable_stories, to: 'planned_stories#add_repeatable_stories'
  end

  resources :stories do
    resources :planned_stories, shallow: true
  end

  get :archived_stories, to: 'stories#archived'
  patch 'unarchive_stories/:id', to: 'stories#unarchive', as: :unarchive_story
  get :one_off_stories, to: 'stories#one_off'
  get :repeatable_stories, to: 'stories#repeatable'

  resources :values
end
