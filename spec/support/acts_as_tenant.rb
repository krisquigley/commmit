require_relative './helpers/auth_helper'

RSpec.configure do |config|
  include AuthHelper

  config.before(:each) do |example|
    $default_user = find_or_create_test_user

    if example.metadata[:type] == :request
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = $default_user.accounts.first
      Capybara.app_host = "http://#{$default_user.accounts.first.subdomain}.lvh.me"
      Capybara.always_include_port = true
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = $default_user.accounts.first
      Capybara.app_host = "http://#{$default_user.accounts.first.subdomain}.lvh.me"
      Capybara.always_include_port = true
    end
  end
  
  config.after(:each) do |example|
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end
end