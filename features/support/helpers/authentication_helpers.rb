# frozen_string_literal: true

def create_user(username = 'default')
  @user ||= User.find_by(username: username) || create(:confirmed_user, username: username,
                                                                        password: 'testing123')

  @tenant = @user.personal_account
  ActsAsTenant.current_tenant = @tenant
  Capybara.app_host = "http://#{@tenant.subdomain}.lvh.me"
  Capybara.always_include_port = true

  @user
end
