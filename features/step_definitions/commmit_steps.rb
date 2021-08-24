# frozen_string_literal: true

##
# Given

Given('I have a Commmit with a Commmit Goal and {int} planned stories') do |_int|
  with_tenant do
    @commmit = commmit_with_a_commmit_goal
  end
end

Given('I have an elapsed Commmit with a user entered goal') do
  with_tenant do
    @commmit = create(:finished_commmit, { name: 'user entered goal', goal_id: nil })
  end
end

Given('I have an elapsed Commmit with the Commmit goal completed') do
  with_tenant do
    @commmit = finished_commmit_with_completed_commmit_goal
  end
end

Given('I have an elapsed Commmit with the Commmit goal not completed') do
  with_tenant do
    @commmit = finished_commmit_with_incomplete_commmit_goal
  end
end

Given('that I have no Commmits in progress') do
  with_tenant do
    @commmit = create(:finished_commmit)
  end
end

Given('I have a finished Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = finished_commmit_with_planned_stories(stories_count: number)
  end
end

Given('I have a reflected Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = finished_commmit_with_completed_planned_stories_and_reflection(stories_count: number)
  end
end

Given('I already have an Archived Commmit') do
  with_tenant do
    @commmit = create(:discarded_commmit)
  end
end

Given('a Commmit on that day') do
  with_tenant do
    @existing_commmit = create(:commmit, end_date: @commmit.end_date)
  end
end

Given('I have an unfinished Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_planned_stories(stories_count: number)
  end
end

Given('I already have a Commmit with {int} planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_planned_stories(stories_count: number)
  end
end

Given('a Repeatable Story with {string}') do |goal|
  with_tenant do
    create(:repeatable_story, goal: goal)
  end
end

Given('I have a reflected Commmit') do
  with_tenant do
    @commmit = finished_commmit_with_completed_planned_stories_and_reflection
  end
end

Given('I have a finished Commmit') do
  with_tenant do
    @commmit = create(:finished_commmit)
  end
end

Given('I already have a Commmit for today') do
  with_tenant do
    @commmit = create(:commmit)
  end
end

Given('I am creating a Commmit') do
  visit new_commmit_path
end

Given('a Story with {string}') do |goal|
  with_tenant do
    @story = create(:story, goal: goal)
  end
end

Given('I already have a Commmit which is in progress') do
  with_tenant do
    @commmit = create(:commmit, end_date: Time.current.to_date)
  end
end

Given('a Story') do
  with_tenant do
    @story = create(:story)
  end
end

Given('I already have a Commmit with {int} completed planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_completed_planned_stories(stories_count: number)
  end
end

Given('I already have a Commmit with {int} repeatable planned stories') do |number|
  with_tenant do
    @commmit = commmit_with_repeatable_planned_stories(stories_count: number)
  end
end

Given('I have an elapsed Commmit') do
  with_tenant do
    @commmit = create(:finished_commmit)
  end
end

Given('I already have a Commmit which has finished') do
  with_tenant do
    @commmit = create(:commmit, end_date: Date.yesterday)
  end
end

Given('I already have {int} automatic repeatable stories') do |number|
  with_tenant do
    @stories = create_list(:automatic_repeatable_story, number)
  end
end

Given('that I have a Commmit in progress') do
  with_tenant do
    @commmit = create(:commmit)
  end
end

##
# When

When('I create a Commmit and choose a goal') do
  visit new_commmit_path

  find('button[name="choose_goal"]').click

  find_all('button[name="choose"]').first.click

  with_tenant do
    expect(page).to have_content Story.incomplete.one_off.kept.most_recent_first.first.goal
  end
end

When('I choose a Commmit Goal') do
  visit new_commmit_path

  find('button[name="choose_goal"]').click
end

When('I create a Commmit and choose a repeatable goal') do
  visit new_commmit_path

  find('button[name="choose_goal"]').click

  find_link(t('stories.form.repeatable.forever')).click

  find_all('button[name="choose"]').first.click

  with_tenant do
    expect(page).to have_content Story.incomplete.repeatable.kept.most_recent_first.first.goal
  end
end

When('I create a Commmit and create a new goal') do
  visit new_commmit_path

  find('button[name="choose_goal"]').click

  click_on t('stories.index.new_story')

  find('input[id=story_goal]').set('new goal')

  find("input[value='#{t('stories.form.create')}']").click

  submit_form
end

When('I archive my Commmit') do
  visit commmits_path

  accept_alert do
    click_archive_button('commmit')
  end
end

When('I unarchive the Commmit') do
  find('button[name="unarchive_commmit"]').click
end

When('I visit archived Commmits') do
  find('button[data-toggle="collapse"]').click

  click_on t('commmits.archived.header')
end

When('I click on Today') do
  visit commmits_path
  click_on 'Today'
end

When('I create a new story with {string} from my Commmit') do |goal|
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  click_on t('stories.index.new_story')

  find('input[id=story_goal]').set(goal)

  submit_form
end

When('I create a Commmit with the name test') do
  visit new_commmit_path

  find(:css, "input[name*='name']").set('Test')

  submit_form
end

When('I create a new Commmit with invalid details') do
  click_link t('commmits.index.new_commmit')

  submit_form
end

When('I click {string}') do |string|
  find("label[for='#{string.downcase}']").click
end

When('I add a one-time Story') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  first("button[name='add']").click
end

When('I add a repeatable story') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  click_on t('stories.form.repeatable.forever')

  first("button[name='add']").click
end

When('I remove a planned story') do
  visit commmit_planned_stories_path(@commmit)

  first("button[name='remove_story']").click
end

When('I mark the planned story as done') do
  with_tenant do
    visit commmit_planned_stories_path(@commmit)
    find_all('button[name=done]').last.click
  end
end

When('I mark the planned story as not done') do
  with_tenant do
    visit commmit_planned_stories_path(@commmit)
    find('button[name=not_done]').click
  end
end

When('I try to create a new Commmit') do
  visit new_commmit_path
end

When('I view the Commmit') do
  visit commmit_planned_stories_path(@commmit)
end

When('I create a Commmit with the name test and choose to start it today') do
  visit new_commmit_path

  find('button[name="choose_goal"]').click

  find_all('button[name="choose"]').first.click

  find("label[for='today']").click

  submit_form
end

##
# Then

Then('I should be able to change the goal before creating it') do
  find('button[name="choose_goal"]').click

  find_all('button[name="choose"]')[1].click

  submit_form
end

Then('see the goal in my list of Commmits once I have created it') do
  with_tenant do
    commmit = Commmit.first
    expect(commmit.goal_id).to be_present
    expect(commmit.commmit_goal).to be_present
    expect(page).to have_content(Story.find(commmit.goal_id).goal)
  end
end

Then('I should be able to see the Commmit again') do
  visit commmits_path

  expect(page).to have_content @commmit.name
end

Then('my Commmit should still be listed') do
  expect(page).to have_content @commmit.name
end

Then('I should be alerted that something is wrong') do
  expect(page).to have_content t('commmits.form.name.presence_msg')
end

Then('I should see my most recent Commmits') do
  expect(page).to have_content @commmits.first.name
end

Then('I should not be able to edit the Commmit') do
  expect(page).to have_content t('commmits.planned_stories.index.finished')
end

Then('I can see my planned stories') do
  with_tenant do
    expect(@commmit.planned_stories.count).to be_positive

    @commmit.stories.each do |story|
      expect(page).to have_content story.goal
    end
  end
end

Then('I should see the updated details') do
  visit commmit_planned_stories_path(@commmit)

  expect(page).to have_content @commmit.name
end

Then('I should no longer see my Commmit') do
  visit commmits_path

  expect(page).to_not have_content @commmit.name
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

Then('I should see that it finishes today') do
  expect(page).to have_content t('commmits.index.statuses.in_progress')
end

Then('I should see that it finished yesterday') do
  expect(page).to have_content t('commmits.index.statuses.finished')
end

Then('I should not be able to add the Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  expect(page).to have_content t('commmits.planned_stories.index.add_story')
end

Then('I should be able to add the Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  click_on t('stories.form.repeatable.forever')

  first("button[name='add']").click
end

Then('it should not be listed under my commmit anymore') do
  with_tenant do
    within('div[data-container="planned_stories"]') do
      expect(page).to_not have_content Story.where.not(id: @commmit.goal_id).first.goal
    end
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
    expect(@commmit.planned_stories.last.completed?).to be_truthy
    expect(@commmit.planned_stories.last.story.completed?).to be_truthy
  end
end

Then('the planned story and story should not be marked as done') do
  with_tenant do
    expect(@commmit.planned_stories.first.completed?).to be_falsy
    expect(@commmit.planned_stories.first.story.completed?).to be_falsy
  end
end

Then('I can still add the repeatable Story again') do
  visit commmit_planned_stories_path(@commmit)
  click_on t('commmits.planned_stories.index.add_stories')

  click_on t('stories.form.repeatable.forever')

  first("button[name='add']").click
end

Then('see the repeatable stories in my list of planned stories') do
  with_tenant do
    visit commmit_planned_stories_path(Commmit.first)

    planned_stories = find_all("div[data-element='planned_story']")

    # INFO: Chosen Commmit goal is an auto added story
    expect(planned_stories.length).to eq 3

    @stories.each do |story|
      within("div[data-container='planned_stories']") do
        expect(page).to have_content story.goal
      end
    end
  end
end

Then('I should be notified that I have no Commmits today') do
  expect(page).to have_content t('commmits.alert.no_commmits_today')
end

Then('I should be taken to the Commmit in progress') do
  expect(page).to have_content @commmit.name
end

Then('I should be notified that a Commmit already exists for today') do
  expect(page).to have_content t('activerecord.errors.models.commmit.attributes.end_date.taken')
end

Then('I should see my Commmit Goal at the top of the list') do
  first_planned_story = find("[data-element='planned_story']", match: :first)
  with_tenant do
    commmit_goal = @commmit.commmit_goal.story

    expect(first_planned_story).to have_content commmit_goal.goal
  end
end

Then('I cannot remove it') do
  first_planned_story = find("[data-element='planned_story']", match: :first)

  expect do
    first_planned_story.find("button[name='remove_story']")
  end.to raise_error Capybara::ElementNotFound
end
