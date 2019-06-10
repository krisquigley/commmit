require "rails_helper"

RSpec.describe "Retrospectives", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end
  
  describe "closing sprint", js: true do
    let!(:department) { create(:department_with_teams) }
    let!(:sprint) { create(:sprint, team: department.teams.first) }
    let!(:tickets) { create_list(:ticket, 5) }
    
    it "should show leave feedback button" do
      visit sprint_path(sprint)

      click_on 'Close Sprint'
      page.accept_alert

      expect(page).to have_link "Retrospective Feedback"
    end
  end

  context "adding user feedback to a sprint" do
    describe "with valid data" do
      let!(:department) { create(:department_with_teams) }
      let!(:sprint) { create(:sprint, team: department.teams.first) }
      let!(:tickets) { create_list(:ticket, 5) }
      
      it "should get added" do
        visit sprint_retrospective_path(sprint)

        find("[id=retrospective_role_happiness]", match: :first).set 2
        find('[id=retrospective_team_happiness]', match: :first).set 2
        find('[id=retrospective_company_happiness]', match: :first).set 2
        find('[id=retrospective_feedback]', match: :first).set 'this and this'
        find('[id=retrospective_happiness_goal]', match: :first).set 'some other stuff'

        find('[value=Submit]', match: :first).click

        expect(page).to have_content 'some other stuff'
      end
    end

    describe "with invalid data" do
      let!(:department) { create(:department_with_teams) }
      let!(:sprint) { create(:sprint, team: department.teams.first) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should not get added" do
        visit sprint_retrospective_path(sprint)

        find('[value=Submit]', match: :first).click

        expect(page).to have_content "Role happiness can't be blank Role happiness is not a number Team happiness can't be blank Team happiness is not a number Company happiness can't be blank Company happiness is not a number Feedback can't be blank Happiness goal can't be blank"
      end
    end
  end
end