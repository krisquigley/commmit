# frozen_string_literal: true

When('I mark my goal as being completed') do
  find("label[for='goal_met_true']").click
end

Then('I should be able to see that the goal was manually met') do
  submit_form

  visit commmit_reflection_path(@commmit)

  expect(page.find('label[for="goal_met_true"]')[:class].include?('active')).to be_truthy
  expect(page.find('label[for="goal_met_false"]')[:class].include?('active')).to be_falsy
  with_tenant do
    expect(@commmit.reflection.goal_met).to be_truthy
  end
end

Then('I should be able to see that the goal was met') do
  submit_form

  visit commmit_reflection_path(@commmit)

  expect(page).to have_content ActionController::Base.helpers.strip_tags(t('commmits.reflection.goal_met_msg_html'))
  with_tenant do
    expect(@commmit.reflection.goal_met).to be_truthy
  end
end

Then('I should be able to see that the goal was not met') do
  submit_form

  visit commmit_reflection_path(@commmit)

  expect(page).to have_content ActionController::Base.helpers.strip_tags(t('commmits.reflection.goal_not_met_msg_html'))
  with_tenant do
    expect(@commmit.reflection.goal_met).to be_falsy
  end
end

When('I reflect on the Commmit') do
  visit new_commmit_reflection_path(@commmit)
end

Then("I should be shown what I have and haven't completed") do
  with_tenant do
    within "section[id='completed_stories']" do
      @commmit.planned_stories.completed.each do |planned_story|
        expect(page).to have_content planned_story.story.goal
      end
    end

    within "section[id='incomplete_stories']" do
      @commmit.planned_stories.todo.each do |planned_story|
        expect(page).to have_content planned_story.story.goal
      end
    end
  end
end

When('I add notes to my Reflection') do
  fill_in 'notes', with: 'my notes'
end

When('I record my happiness') do
  within "form[action='#{commmit_reflection_path(@commmit)}']" do
    choose(option: '3')
  end
end

Then('I should be able to view the completed reflection') do
  with_tenant do
    expect(page).to have_content t('commmits.planned_stories.index.view_reflection')

    click_on t('commmits.planned_stories.index.view_reflection')

    expect(page).to have_current_path(commmit_reflection_path(@commmit))
    expect(page).to have_content(@commmit.reflection.notes)
  end
end

Then('I should be able to see my notes') do
  submit_form

  visit commmit_reflection_path(@commmit)

  with_tenant do
    expect(page).to have_content 'my notes'
  end
end

Then('I should see my happiness recorded') do
  submit_form

  visit commmit_reflection_path(@commmit)

  with_tenant do
    expect(@commmit.reflection.happiness).to eq 3
  end
end

Then('I should be prompted to reflect') do
  expect(page).to have_current_path(new_commmit_reflection_path(@commmit, redirect: true))
end

Then('I can view my Reflection') do
  click_on t('commmits.planned_stories.index.view_reflection')

  expect(page).to have_content t('commmits.reflection.new.completed_stories')
end
