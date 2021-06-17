When('I sign up with correct details') do
  user = build(:user)
  visit signup_path

  fill_in t('users.form.username.label'), with: user.username
  fill_in t('users.form.email.label'), with: user.email
  fill_in t('users.form.password.label'), with: user.password
  fill_in t('users.form.password_confirmation.label'), with: user.password

  submit_form
end

When('I sign up with missing details') do
  visit signup_path

  submit_form
end

Then('I should be shown a missing details error') do
  expect(page).to have_content "#{t('users.form.email.label')} #{t('errors.messages.blank')}"
  expect(page).to have_content "#{t('users.form.password.label')} #{t('errors.messages.blank')}"
  expect(page).to have_content "#{t('users.form.username.label')} #{t('errors.messages.blank')}"
end

When('I sign up with an incorrect usename format') do
  visit signup_path
  fill_in t('users.form.username.label'), with: 'bad username$.'

  submit_form
end

Given('a user already exists with the same name or domain') do
  @user = build(:user)
  create(:account, name: 'Existing Account', subdomain: @user.username, owner_user_id: 5)
end

When('I sign up with the same name') do
  visit signup_path

  fill_in t('users.form.username.label'), with: @user.username
  fill_in t('users.form.email.label'), with: @user.email
  fill_in t('users.form.password.label'), with: @user.password
  fill_in t('users.form.password_confirmation.label'), with: @user.password

  submit_form
end

Then('I should be shown an incorrect username error') do
  expect(page).to have_content t('users.validation.username')
end

Then('I should be shown an account already exists error') do
  expect(page).to have_content "Accounts #{t('errors.messages.invalid')}"
  expect(Account.count).to eq 2 # 'testing-account' is created for all the tests
  expect(User.count).to eq 1
end
