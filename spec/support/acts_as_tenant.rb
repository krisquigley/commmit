require_relative './helpers/auth_helper'

RSpec.configure do |config|
  include AuthHelper

  config.before(:each) do |example|
    default_user = find_or_create_test_user
    $tenant = default_user.personal_account


    if example.metadata[:type] == :request
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = $tenant
      Capybara.app_host = "http://#{$tenant.subdomain}.lvh.me"
      Capybara.always_include_port = true
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = $tenant
      Capybara.app_host = "http://#{$tenant.subdomain}.lvh.me"
      Capybara.always_include_port = true
    end
  end
  
  config.after(:each) do |example|
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end
end