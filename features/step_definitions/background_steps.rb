# frozen_string_literal: true

Given('a default user') do
  user = User.find_by(username: 'testing-account') ||
         User.create(username: 'testing-account',
                     password: 'testing123',
                     password_confirmation: 'testing123',
                     email: 'default@example.com',
                     confirmed_at: Time.now)

  tenant = user.personal_account
  ActsAsTenant.current_tenant = tenant
  Capybara.app_host = "http://#{tenant.subdomain}.lvh.me"
end

Given('already logged in') do
  user = User.first

  visit '/users/sign_in'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'testing123'

  click_on t('sessions.new.form.create')
end
