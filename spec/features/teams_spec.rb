require 'rails_helper'

RSpec.describe "Teams", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "viewing a team" do
    let!(:department) { create(:department_with_teams) }
    let!(:sprint) { create(:sprint_with_tickets, team: department.teams.first) }

    it "should list the sprints" do
      visit team_path(department.teams.first)

      expect(page).to have_content sprint.name
    end
  end

  describe "adding a team with valid data" do
    let!(:department) { create(:department) }
    let!(:user) { create(:user) }

    it "should create the team" do
      visit department_path(department)

      click_on 'Add Team'

      fill_in 'Name', with: 'test'
      check user.name

      click_on 'Create Team'

      expect(page).to have_content 'test'
    end
  end

  describe "adding a team with invalid data" do
    let!(:department) { create(:department) }
    let!(:user) { create(:user) }

    it "should not create the team" do
      visit department_path(department)

      click_on 'Add Team'

      check user.name

      click_on 'Create Team'

      expect(page).to have_content 'Name can\'t be blank'
    end
  end
end
