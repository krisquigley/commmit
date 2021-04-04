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
                        ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
        ActiveSupport::SecurityUtils
        .secure_compare(::Digest::SHA256.hexdigest(password),
                        ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'

  get '/',  to: 'commmits#current_commmit',
            constraints: {
              subdomain: /.+/
            },
            as: :logged_in

  root 'static_pages#show'

  devise_scope :user do
    get 'login',  to: 'users/sessions#new'
    get 'logout', to: 'users/sessions#destroy'
    get 'signup', to: 'users/registrations#new'
  end

  devise_for  :users,
              controllers: {
                registrations: 'users/registrations',
                sessions: 'users/sessions',
                confirmations: 'users/confirmations',
                passwords: 'users/passwords',
                unlocks: 'users/unlocks'
              }

  resources :commmits

  resources :stories do
    resources :planned_stories, shallow: true do
      patch :mark_as_done
      patch :mark_as_not_done
    end
  end

  resources :tags, only: %i[index create destroy]
end
