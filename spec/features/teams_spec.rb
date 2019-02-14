require 'rails_helper'

RSpec.describe "teams", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in 
  end

  context "creating a team" do
    describe "with invalid data" do
      it "should raise an error" do
        visit new_team_path

        click_on 'Create Team'
      
        expect(page).to have_content("Name can't be blank User ids can't be blank")
      end
    end

    describe "with valid data" do
      let!(:user) { create(:user) }

      it "should create a team" do
        visit new_team_path

        fill_in 'Name', with: 'my team'

        find("input[value='#{user.id}']").check
        click_on 'Create Team'
      
        expect(page).to have_content("my team")
      end
    end
  end

  context "editing a team" do
    let!(:users) { create_list(:user, 5) }
    let!(:team) { create(:team, user_ids: users.pluck(:id)) }

    describe "with invalid data" do
      it "should raise an error" do
        visit edit_team_path(team)

        fill_in 'Name', with: ''

        click_on 'Update Team'

        expect(page).to have_content("Name can't be blank")
      end
    end

    describe "with valid data" do
      it "should update the team" do
        visit edit_team_path(team)

        fill_in 'Name', with: 'my team'
        find("input[value='#{users.first.id}']").uncheck
        
        click_on 'Update Team'

        expect(team.reload.users.count).to eq(4)
        expect(page).to have_content("my team")
      end
    end
  end
end