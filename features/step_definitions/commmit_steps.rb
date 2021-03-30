# frozen_string_literal: true

When('I create a Commmit with the name test') do
  click_link t('commmits.index.new_commmit')

  find(:css, "input[name*='name']").set('Test')

  submit_form
end

Then('I should be notified that it was created') do
  expect(page).to have_content t('commmits.notice.created')
end

Then('see Test in my list of Commmits') do
  visit commmits_path
  expect(page).to have_content 'Test'
end
