# frozen_string_literal: true

Then('I should be alerted that something is wrong') do
  message = page.find('#commmit_name').native.attribute('validationMessage')
  expect(message).to eq 'Please fill out this field.'
end

Then('I should see my most recent Commmits') do
  expect(page).to have_content @commmits.last.name
end

Given('I have a finished Commmit with planned stories') do
  with_tenant do
    @commmit = finished_commmit_with_planned_stories
  end
end

Then('I should not be able to edit the Commmit') do
  expect(page).to have_content t('commmits.show.finished')
end

Given('I have an unfinished Commmit with planned stories') do
  with_tenant do
    @commmit = commmit_with_planned_stories
  end
end

Then('I can see my planned stories') do
  with_tenant do
    expect(@commmit.planned_stories.count).to be.positive?

    @commmit.stories.each do |story|
      expect(page).to have_content story.goal
    end
  end
end

Given('I already have a Commmit with planned stories') do
  with_tenant do
    @commmit = commmit_with_planned_stories
  end
end

Then('I should see the updated details') do
  visit commmit_path(@commmit)

  expect(page).to have_content @commmit.name
end

When('I archive my Commmit') do
  visit commmits_path

  find(:css, "button[name='archive_commmit']").click
end

Then('I should no longer see my Commmit') do
  visit commmits_path

  expect(page).to_not have_content @commmit.name
end

When('I click on the home logo') do
  visit commmits_path
  find(:css, "img[alt='Commmit']").click
end

Then('I should be taken to my latest Commmit') do
  with_tenant do
    expect(page).to have_content @commmit.stories.first.goal
  end
end

Then('the Story should appear in my Commmit') do
  visit commmit_path(@commmit)

  with_tenant do
    expect(page).to have_content @commmit.story.first.goal
  end
end

When('I create a Commmit with the name test') do
  click_link t('commmits.index.new_commmit')

  find(:css, "input[name*='name']").set('Test')

  submit_form
end

When('I create a new Commmit with invalid details') do
  click_link t('commmits.index.new_commmit')

  submit_form
end
