# frozen_string_literal: true

Given('a {string} user') do |username|
  @user = User.find_by(username: username) || create(:confirmed_user, username: username)

  @tenant = @user.personal_account
  ActsAsTenant.current_tenant = @tenant
  Capybara.app_host = "http://#{@tenant.subdomain}.lvh.me"
  Capybara.always_include_port = true
end

Given('already logged in') do
  user = User.first

  visit '/users/sign_in'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'testing123'

  click_on t('sessions.new.form.create')
end
