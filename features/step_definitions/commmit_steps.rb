# frozen_string_literal: true

Then('I should be alerted that something is wrong') do
  message = page.find('#commmit_name').native.attribute('validationMessage')
  expect(message).to eq 'Please fill out this field.'
end

Then('I should see my most recent Commmits') do
  expect(page).to have_content @commmits.last.name
end

Given('I have a finished Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = finished_commmit_with_planned_stories(stories_count: number)
  end
end

Then('I should not be able to edit the Commmit') do
  expect(page).to have_content t('commmits.planned_stories.index.finished')
end

Given('I have an unfinished Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_planned_stories(stories_count: number)
  end
end

Then('I can see my planned stories') do
  with_tenant do
    expect(@commmit.planned_stories.count).to be_positive

    @commmit.stories.each do |story|
      expect(page).to have_content story.goal
    end
  end
end

Given('I already have a Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_planned_stories(stories_count: number)
  end
end

Then('I should see the updated details') do
  visit commmit_planned_stories_path(@commmit)

  expect(page).to have_content @commmit.name
end

When('I archive my Commmit') do
  visit commmits_path

  click_archive_button('commmit')
end

Then('I should no longer see my Commmit') do
  visit commmits_path

  expect(page).to_not have_content @commmit.name
end

When('I click on Today') do
  visit commmits_path
  click_on 'Today'
end

Then('I should be taken to my latest Commmit') do
  with_tenant do
    expect(page).to have_content @commmit.stories.first.goal
  end
end

Then('the Story with the goal {string} should appear in my Commmit') do |goal|
  visit commmit_planned_stories_path(@commmit)

  within("div[data-container='planned_stories']") do
    expect(page).to have_content goal
  end
end

Given('a Repeatable Story with {string}') do |goal|
  with_tenant do
    create(:repeatable_story, goal: goal)
  end
end

When('I create a new story with {string} from my Commmit') do |goal|
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')
  find('input[id=story_goal]').set(goal)

  submit_form
end

Given('a Story with {string}') do |goal|
  with_tenant do
    create(:story, goal: goal)
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

Given('I am creating a Commmit') do
  visit new_commmit_path
end

When('I click {string}') do |string|
  find("label[for='#{string.downcase}']").click
end

Then('the date should match tomorrows date') do
  date = find('input[type="date"]')
  expect(date.value).to eq Date.tomorrow.iso8601
end

Then('the date should change back to today') do
  date = find('input[type="date"]')
  expect(date.value).to eq Time.current.to_date.iso8601
end

Then('I should see a message to create a Commmit') do
  expect(page).to have_content t('commmits.index.no_commmits_yet')
end

Then('I can view my Reflection') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I already have a Commmit which is in progress') do
  with_tenant do
    create(:commmit, end_date: Time.current.to_date)
  end
end

Then('I should see that it finishes today') do
  expect(page).to have_content t('commmits.index.statuses.in_progress')
end

Given('I already have a Commmit which has finished') do
  with_tenant do
    create(:commmit, end_date: Date.yesterday)
  end
end

Then('I should see that it finished yesterday') do
  expect(page).to have_content t('commmits.index.statuses.finished')
end

When('I add a one-time Story') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  first("button[name='add']").click
end

Then('I should not be able to add the Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  expect(page).to have_content t('commmits.planned_stories.index.add_story')
end

Given('a Story') do
  with_tenant do
    create(:story)
  end
end

When('I add a repeatable story') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  first("button[name='add']").click
end

Then('I should be able to add the Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  first("button[name='add']").click
end

When('I remove a planned story') do
  visit commmit_planned_stories_path(@commmit)

  first("button[name='remove_story']").click
end

Then('it should not be listed under my commmit anymore') do
  with_tenant do
    within('div[data-container="planned_stories"]') do
      expect(page).to_not have_content Story.first.goal
    end
  end
end

When('I mark the planned story as done') do
  with_tenant do
    visit commmit_planned_stories_path(@commmit)
    find('button[name=done]').click
  end
end

Then('the planned story and story should be marked as done') do
  with_tenant do
    expect(@commmit.planned_stories.first.completed?).to be_truthy
    expect(@commmit.planned_stories.first.story.completed?).to be_truthy
  end
end

Then('the planned story should be marked as done') do
  with_tenant do
    expect(@commmit.planned_stories.first.completed?).to be_truthy
    expect(@commmit.planned_stories.first.story.completed?).to be_truthy
  end
end

Given('I already have a Commmit with {int} completed planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_completed_planned_stories(stories_count: number)
  end
end

When('I mark the planned story as not done') do
  with_tenant do
    visit commmit_planned_stories_path(@commmit)
    find('button[name=not_done]').click
  end
end

Then('the planned story and story should not be marked as done') do
  with_tenant do
    expect(@commmit.planned_stories.first.completed?).to be_falsy
    expect(@commmit.planned_stories.first.story.completed?).to be_falsy
  end
end

Given('I already have a Commmit with {int} repeatable planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_repeatable_planned_stories(stories_count: number)
  end
end

Then('I can still add the repeatable Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  first("button[name='add']").click
end

Given('I already have {int} automatic repeatable stories') do |number|
  with_tenant do
    @stories = create_list(:automatic_repeatable_story, number)
  end
end

Then('see the repeatable stories in my list of planned stories') do
  with_tenant do
    visit commmit_planned_stories_path(Commmit.first)

    @stories.each do |story|
      within("div[data-container='planned_stories']") do
        expect(page).to have_content story.goal
      end
    end
  end
end

Given('that I have no Commmits in progress') do
  with_tenant do
    @commmit = create(:finished_commmit)
  end
end

Then('I should be notified that I have no Commmits today') do
  expect(page).to have_content t('commmits.alert.no_commmits_today')
end

Given('that I have a Commmit in progress') do
  with_tenant do
    @commmit = create(:commmit)
  end
end

Then('I should be taken to the Commmit in progress') do
  expect(page).to have_content @commmit.name
end

Given('I have a finished Commmit') do
  with_tenant do
    create(:finished_commmit)
  end
end

Given('I already have a Commmit for today') do
  with_tenant do
    create(:commmit)
  end
end

Then('I should be notified that a Commmit already exists for today') do
  expect(page).to have_content t('activerecord.errors.models.commmit.attributes.end_date.taken')
end
