# frozen_string_literal: true

Given('a {string} user') do |username|
  create_user(username)
end

Given('already logged in') do
  visit login_path

  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: 'testing123'

  click_on t('sessions.new.form.create')
  expect(page).to have_content t('devise.sessions.signed_in')
end
