# frozen_string_literal: true

When('I reflect on the Commmit') do
  visit new_commmit_reflection_path(@commmit)
end

Then("I should be shown what I have and haven't completed") do
  with_tenant do
    print page.html
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

Then('I should be able to add notes') do
  fill_in 'notes', with: 'my notes'
  choose(option: '3')

  submit_form

  visit commmit_reflection_path(@commmit)

  expect(page).to have_content 'my notes'
end

Then('record my happiness') do
  choose(option: '3')

  submit_form

  visit commmit_reflection_path(@commmit)

  expect(page).to have_content 3
end

Then('I should be able to view the completed reflection') do
  with_tenant do
    expect(page).to have_content t('commmits.planned_stories.index.view_reflection')

    click_on t('commmits.planned_stories.index.view_reflection')

    expect(page).to have_current_path(commmit_reflection_path(@commmit))
    expect(page).to have_content(@commmit.reflection.notes)
  end
end
