
When('I log in with correct details') do
  visit login_path

  fill_in t('users.form.email.label'), with: @user.email
  fill_in t('users.form.password.label'), with: @user.password

  submit_form
end

Then('I should be redirected to the account page') do
  expect(page).to have_current_path(commmits_path)
end

When('I log in with incorrect details') do
  visit login_path

  fill_in t('users.form.email.label'), with: 'blah@blah.com'
  fill_in t('users.form.password.label'), with: 'testing123'

  submit_form
end

Then('I should be shown an invalid email error') do
  expect(page).to have_content t('devise.failure.invalid', authentication_keys: 'Email')
end

When('I log out') do
  visit logged_in_path

  click_on t('sessions.logout')
end

Then('I should be redirected to the landing page') do
  expect(page).to have_current_path(root_path)
end
