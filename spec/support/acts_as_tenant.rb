# frozen_string_literal: true

require_relative './helpers/auth_helper'

RSpec.configure do |config|
  include AuthHelper

  config.before(:each) do |example|
    default_user = find_or_create_test_user
    tenant = default_user.personal_account

    if example.metadata[:type] == :request
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = tenant
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = tenant
    end
    Capybara.app_host = "http://#{tenant.subdomain}.lvh.me"
    Capybara.always_include_port = true
  end

  config.after(:each) do |_example|
    ActsAsTenant.with_tenant User.first.personal_account do
      Story.clear_index!
    end
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end
end
