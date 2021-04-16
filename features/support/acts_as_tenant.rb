# frozen_string_literal: true

Before do
  create_user
end

Before('@request') do
  ActsAsTenant.test_tenant = User.first.personal_account
end

After do
  # Clear any tenancy that might have been set
  ActsAsTenant.current_tenant = nil
  ActsAsTenant.test_tenant = nil
end
