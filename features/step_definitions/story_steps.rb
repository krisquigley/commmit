# frozen_string_literal: true

Given('I have an archived Story') do
  with_tenant do
    @story = create(:discarded_story)
  end
end

Given('I have some stories') do
  with_tenant do
    @stories = create_list(:story, 5)
  end
end

Given('I am creating a repeatable Story') do
  visit new_story_path

  find("input[name*='goal']").set('Test')
  find("label[for='story_repeatable_true']").click

  click_on t('stories.form.cancel')
end

Given('I already have a one-off story') do
  with_tenant do
    @story = create(:story, repeatable: false)
  end
end

Given('I already have a repeatable story') do
  with_tenant do
    @story = create(:story, repeatable: true)
  end
end

Given('I already have {int} stories') do |int|
  @stories = create_list(:story, int)
  @story = @stories.last
end

Given('I already have {int} repeatable stories') do |int|
  @stories = create_list(:story, int, repeatable: true)
  @story = @stories.last
end

When('I choose to make the Story get automatically added') do
  find("label[for='story_repeatable_true']").click
  find("label[for='story_automatically_add_true']").click

  submit_form
end

When('I visit archived stories') do
  find('button[data-toggle="collapse"]').click

  click_on t('stories.archived.header')
end

When('I click unarchive') do
  find('button[name="unarchive_story"]').click
end

When('I archive my Story') do
  visit stories_path

  accept_alert do
    click_archive_button('story')
  end
end

When('I create a Story with the goal of {string}') do |goal|
  visit stories_path

  click_button t('stories.index.new_story')

  find("input[name*='goal']").set(goal)

  submit_form
end

When('I create a new Story with invalid details') do
  visit stories_path

  click_button t('stories.index.new_story')

  submit_form
end

When("I edit the Story's goal") do
  visit stories_path

  find("a[href*='/edit']").click

  find("input[name*='goal']").set('My new goal')

  submit_form
end

When('I create a repeatable Story') do
  visit new_story_path

  find("input[name*='goal']").set('Test')
  find("label[for='story_repeatable_true']").click

  submit_form
end

When('I create a one-time Story') do
  visit new_story_path

  find("input[name*='goal']").set('Test')
  find("label[for='story_repeatable_false']").click

  submit_form
end

Then('I should no longer see my Story') do
  visit stories_path

  expect(page).to_not have_content @story.goal
end

Then('will see the changes to my Story') do
  visit stories_path

  expect(page).to have_content 'My new goal'
end

Then('I should see it in my list of stories') do
  visit stories_path

  expect(page).to have_content(@story.goal)
end

Then('I should be alerted that something is missing') do
  message = page.find('#story_goal').native.attribute('validationMessage')
  expect(message).to eq 'Please fill out this field.'
end

Then('my Story should have no repeat icon') do
  visit stories_path

  within("div[data-container='story']") do
    expect(page).to_not have_css("svg[name='repeat_icon']")
  end
end

Then('my Story should have a repeat icon') do
  visit stories_path

  click_on t('stories.form.repeatable.forever')

  within("div[data-container='story']") do
    expect(page).to have_css("img[data-test-id='repeat_icon']")
  end
end

Then('I should see my one-off Story under the Once tab') do
  within("div[data-container='one_off_stories']") do
    expect(page).to have_content @story.goal
  end
end

Then('I should see my repeatable Story under the Repeatable tab') do
  visit stories_path
  click_on t('stories.form.repeatable.forever')
  within("div[data-container='repeatable_stories']") do
    expect(page).to have_content @story.goal
  end
end

Then('I should see a cog icon next to it') do
  visit stories_path

  find("a[id='2']").click

  within("div[data-container='repeatable_stories']") do
    expect(page).to have_css "img[data-test-id='automatically_add']"
  end
end

Then('I should be able to load more stories') do
  container = find('div[data-test="stories-container"]')
  container.scroll_to(:bottom)
  find('a[data-test="load-more"]').click

  expect(page).to have_content @stories.first.goal
end

When('I have completed some stories') do
  @completed_stories = @stories[0..3]
  @incomplete_stories = @stories[4..9]

  @completed_stories.each_with_index do |story, index|
    story.update(completed_at: Time.zone.now + index.hours)
  end
end

Then('I should see the non-completed newest stories first') do
  visit stories_path
  click_on t('stories.form.repeatable.forever')

  within 'div[data-container="repeatable_stories"]' do
    stories = find_all('div[data-container="story"]')
    expect(stories.count).to eq 10

    incomplete_stories = Story.incomplete.order(created_at: :desc)

    stories[0..5].each_with_index do |story, index|
      expect(story).to have_content incomplete_stories[index].goal
    end
  end
end

Then('I should see the most recent completed stories afterwards') do
  visit stories_path
  click_on t('stories.form.repeatable.forever')

  within 'div[data-container="repeatable_stories"]' do
    stories = find_all('div[data-container="story"]')
    expect(stories.count).to eq 10

    completed_stories = Story.complete.order(completed_at: :desc)

    stories[6..9].each_with_index do |story, index|
      expect(story).to have_content completed_stories[index].goal
    end
  end
end
