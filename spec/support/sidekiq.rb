require 'sidekiq/testing'
require_relative './helpers/auth_helper'

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

RSpec.configure do |config|
  config.profile_examples = true
  config.before(:suite) do
    Sidekiq::Testing.fake!
  end
 
  config.around(:example, sidekiq: -> (mode) { !!mode }) do |example|
    unless %i(inline fake disable).include?(example.metadata.fetch(:sidekiq))
      raise "sidekiq_mode must be :inline, :fake or :disable"
    end
    Sidekiq::Testing.send("#{example.metadata.fetch(:sidekiq)}!".to_sym) do
      default_user = find_or_create_test_user

      ActsAsTenant.with_tenant default_user.personal_account do
        example.run
      end
    end
  end
end