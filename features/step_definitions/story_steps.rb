When('I archive my Story') do
  visit stories_path

  click_archive_button('story')
end

Then('I should no longer see my Story') do
  visit stories_path

  expect(page).to_not have_content @story.goal
end

When('I create a Story with the goal of {string}') do |goal|
  visit stories_path

  click_link t('stories.index.new_story')

  find("input[name*='goal']").set(goal)

  submit_form
end

Then('stay on the form to add more Stories') do
  expect(page).to have_current_path new_story_path
end

When('I create a new Story with invalid details') do
  visit stories_path

  click_link t('stories.index.new_story')

  submit_form
end

Then('I should be alerted that something is missing') do
  message = page.find('#story_goal').native.attribute('validationMessage')
  expect(message).to eq 'Please fill out this field.'
end

When("I edit the Story's goal") do
  visit stories_path

  find("a[href*='/edit']").click

  find("input[name*='goal']").set('My new goal')

  submit_form
end

Then('will see the changes to my Story') do
  visit stories_path

  expect(page).to have_content 'My new goal'
end

When('I create a one-time Story') do
  visit new_story_path

  find("input[name*='goal']").set('Test')
  find("input[value='false']").click

  submit_form
end

Then('my Story should have no repeat icon') do
  visit stories_path

  within("div[data-container='story']") do
    expect(page).to_not have_css("svg[name='repeat_icon']")
  end
end

When('I create a repeatable Story') do
  visit new_story_path

  find("input[name*='goal']").set('Test')
  find("input[value='true']").click

  submit_form
end

Then('my Story should have a repeat icon') do
  visit stories_path

  within("div[data-container='story']") do
    expect(page).to have_css("svg[name='repeat_icon']")
  end
end

Given('I already have a one-off story') do
  with_tenant do
    @story = create(:story, repeatable: false)
  end
end

Then('I should see my one-off Story under the Once tab') do
  within("div[data-container='one_off_stories']") do
    expect(page).to have_content @story.goal
  end
end

Given('I already have a repeatable story') do
  with_tenant do
    @story = create(:story, repeatable: true)
  end
end

Then('I should see my repeatable Story under the Repeatable tab') do
  visit stories_path

  within("div[data-container='repeatable_stories']") do
    expect(page).to have_content @story.goal
  end
end
