require "rails_helper"

RSpec.describe "Retrospectives", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end
  
  describe "closing sprint", js: true do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:tickets) { create_list(:ticket, 5) }
    
    it "should show leave feedback button" do
      visit sprint_path(sprint)

      click_on 'Close Sprint'
      sleep 1
      within "form[action='#{sprint_path(sprint)}']" do
        click_on 'Close Sprint'
      end

      expect(page).to have_link "Retrospective Feedback"
    end
  end

  context "adding user feedback to a sprint" do
    describe "with valid data" do
      let!(:team) { create(:team_with_users) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }
      
      it "should get added" do
        visit sprint_retrospective_path(sprint)

        find("[id=retrospective_role_happiness]", match: :first).set 2
        find('[id=retrospective_team_happiness]', match: :first).set 2
        find('[id=retrospective_company_happiness]', match: :first).set 2
        find('[id=retrospective_feedback]', match: :first).set 'this and this'
        find('[id=retrospective_happiness_goal]', match: :first).set 'some other stuff'

        find('[value=Submit]', match: :first).click

        visit sprint_retrospective_path(sprint)

        expect(page).to have_content 'some other stuff'
        expect(page).to have_content 'this and this'
        expect(find("[id=retrospective_role_happiness]", match: :first).value).to eq "2.0"
      end
    end

    describe "with invalid data" do
      let!(:team) { create(:team_with_users) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should not get added", js: true do
        visit sprint_retrospective_path(sprint)

        find('[value="Submit Feedback"]').click
        
        expect(find('[value="Submit Feedback"]').disabled?).to_not be_truthy
      end
    end
  end
end