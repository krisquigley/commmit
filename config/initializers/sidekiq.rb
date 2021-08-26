# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = if Rails.env.production?
                   { url: ENV.fetch('REDIS_TLS_URL') }
                 else
                   { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = if Rails.env.production?
                   { url: ENV.fetch('REDIS_TLS_URL') }
                 else
                   { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
                 end
end
