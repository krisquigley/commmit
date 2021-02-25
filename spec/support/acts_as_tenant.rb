RSpec.configure do |config|
  config.before(:each) do |example|
    $default_user = User.find_by(username: 'www') || User.create(username: 'www', password: 'default123', 
                                                                password_confirmation: 'default123', 
                                                                email: 'default@example.com',
                                                                confirmed_at: Time.now)

    if example.metadata[:type] == :request
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = $default_user.accounts.first
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = $default_user.accounts.first
    end
  end
  
  config.after(:each) do |example|
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end
end