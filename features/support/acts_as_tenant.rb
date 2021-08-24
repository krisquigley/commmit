# frozen_string_literal: true

Before do
  create_user
end

Before('@request') do
  ActsAsTenant.test_tenant = User.first.personal_account
end

After do
  ActsAsTenant.with_tenant User.first.personal_account do
    Story.clear_index!
  end
  # Clear any tenancy that might have been set
  ActsAsTenant.current_tenant = nil
  ActsAsTenant.test_tenant = nil
end
