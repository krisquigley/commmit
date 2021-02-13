require 'acts_as_tenant/sidekiq'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add ActsAsTenant::Sidekiq::Client
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add ActsAsTenant::Sidekiq::Client
  end
  config.server_middleware do |chain|
    if defined?(Sidekiq::Middleware::Server::RetryJobs)
      chain.insert_before Sidekiq::Middleware::Server::RetryJobs, ActsAsTenant::Sidekiq::Server
    elsif defined?(Sidekiq::Batch::Server)
      chain.insert_before Sidekiq::Batch::Server, ActsAsTenant::Sidekiq::Server
    else
      chain.add ActsAsTenant::Sidekiq::Server
    end
  end
end

ActsAsTenant.configure do |config|
  config.require_tenant = true
end