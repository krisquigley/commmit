# frozen_string_literal: true

When('I reflect on the Commmit') do
  visit new_commmit_reflection_path(@commmit)
end

Then("I should be shown what I have and haven't completed") do
  with_tenant do
    within "section[id='completed_stories']" do
      @commmit.planned_stories.completed.each do |story|
        expect(page).to have_content story.goal
      end
    end

    within "section[id='incomplete_stories']" do
      @commmit.planned_stories.todo.each do |story|
        expect(page).to have_content story.goal
      end
    end
  end
end

When('I add notes to my Reflection') do
  within "form[action='#{commmit_reflection_path(@commmit)}']" do
    choose(option: '3')
    choose(option: 'true')
  end

  fill_in 'notes', with: 'my notes'

  submit_form
end

When('record my happiness') do
  within "form[action='#{commmit_reflection_path(@commmit)}']" do
    choose(option: '3')
    choose(option: 'true')
  end

  submit_form
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
  visit commmit_reflection_path(@commmit)

  with_tenant do
    expect(page).to have_content 'my notes'
  end
end

Then('I should see my happiness recorded') do
  visit commmit_reflection_path(@commmit)

  with_tenant do
    expect(@commmit.reflection.happiness).to eq 3
  end
end

Then('I should be prompted to reflect') do
  expect(page).to have_current_path(new_commmit_reflection_path(@commmit, redirect: true))
end
