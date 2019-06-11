require 'rails_helper'

RSpec.describe "Departments", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "viewing a department" do
    let!(:department) { create(:department_with_teams) }

    it "should list the teams" do
      visit department_path(department)

      department.teams.each do |team|
        expect(page).to have_content team.name
      end
    end
  end

  describe "adding a department with valid data" do
    it "should create the department" do
      visit departments_path

      click_on 'New Department'

      fill_in 'Name', with: 'test'

      click_on 'Create Department'

      expect(page).to have_content 'test'
    end
  end

  describe "adding a department with invalid data" do
    it "should not create the department" do
      visit departments_path

      click_on 'New Department'

      click_on 'Create Department'

      expect(page).to have_content 'Name can\'t be blank'
    end
  end
end
