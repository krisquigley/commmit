RSpec.configure do |config|
  config.before(:each) do |example|
    $default_account = Account.find_or_create_by!(name: 'www', subdomain: 'www')
    if example.metadata[:type] == :request
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = $default_account
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = $default_account
    end
  end
  
  config.after(:each) do |example|
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end
end