# frozen_string_literal: true

When('I click on the planned story') do
  visit commmit_planned_stories_path(@commmit)

  with_tenant do
    click_on @commmit.planned_stories.first.story.goal
  end
end

Then('I should be in focus mode') do
  expect(page).to have_content t('commmits.planned_stories.notice.focus_mode')
end

Given('I am focussed on a planned story') do
  with_tenant do
    @commmit = commmit_with_planned_stories
    visit commmit_planned_story_path(@commmit, @commmit.planned_stories.first)
  end
end

Then('I should be able to see the notes') do
  with_tenant do
    expect(page).to have_content @commmit.planned_stories.first.story.notes
  end
end

Then('mark the story as done') do
  click_on 'Done'

  expect(page).to have_content t('stories.notice.done')
end
