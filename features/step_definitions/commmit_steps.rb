# frozen_string_literal: true

When('I create a Commmit with the name test') do
  click_link t('commmits.index.new_commmit')

  find(:css, "input[name*='name']").set('Test')

  submit_form
end

Then('I should be notified that it was {string}') do |notice|
  expect(page).to have_content t("commmits.notice.#{notice}")
end

Then('see {string} in my list of Commmits') do |title|
  visit commmits_path
  expect(page).to have_content title
end

When('I create a new Commmit with invalid details') do
  click_link t('commmits.index.new_commmit')

  submit_form
end

Then('I should be alerted that something is wrong') do
  message = page.find('#commmit_name').native.attribute('validationMessage')
  expect(message).to eq 'Please fill out this field.'
end

Given('I have created some Commmits') do
  ActsAsTenant.with_tenant(@tenant) do
    @commmits = create_list(:commmit, 5)
  end
end

When('I visit the Commmits page') do
  visit commmits_path
end

Then('I should see my most recent Commmits') do
  expect(page).to have_content @commmits.last.name
end
