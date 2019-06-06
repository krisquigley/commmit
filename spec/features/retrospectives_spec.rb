require "rails_helper"

RSpec.describe "Retrospectives", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end
  
  describe "closing sprint", js: true do
    let(:users) { create_list(:user, 1) }
    let!(:sprint) { create(:sprint, users: users) }
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
      let(:users) { create_list(:user, 1) }
      let!(:sprint) { create(:sprint, users: users) }
      let!(:tickets) { create_list(:ticket, 5) }
      
      it "should get added" do
        visit sprint_retrospective_path(sprint)

        fill_in 'Role happiness', with: 2
        fill_in 'Team happiness', with: 2
        fill_in 'Company happiness', with: 2
        fill_in 'Feedback', with: 'this and this'
        fill_in 'Happiness goal', with: 'some other stuff'

        click_on 'Submit'

        expect(page).to have_content 'some other stuff'
      end
    end

    describe "with invalid data" do
      let(:users) { create_list(:user, 1) }
      let!(:sprint) { create(:sprint, users: users) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should not get added" do
        visit sprint_retrospective_path(sprint)

        click_on 'Submit'

        expect(page).to have_content "Role happiness can't be blank Role happiness is not a number Team happiness can't be blank Team happiness is not a number Company happiness can't be blank Company happiness is not a number Feedback can't be blank Happiness goal can't be blank"
      end
    end
  end
end