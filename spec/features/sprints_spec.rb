require "rails_helper"

RSpec.describe "Sprints", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end

  context "creating a sprint" do
    describe "with valid data" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }

      it "should create the sprint" do
        visit new_sprint_path

        fill_in 'Name', with: 'Test'
        select team.name, from: 'sprint_team_id'
        fill_in 'Start date', with: '01/01/2000'
        fill_in 'End date', with: '20/01/200'

        click_on 'Create Sprint'

        expect(page).to have_content('Test')
      end
    end

    describe "with invalid data" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }

      it "should raise an error" do
        visit new_sprint_path

        click_on 'Create Sprint'

        expect(page).to have_content("Name can't be blank Start date can't be blank End date can't be blank Team can't be blank")
      end
    end
  end

  context "managing a sprint" do
    describe "adding a ticket" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }

      it "should be added" do
        create(:ticket)

        visit sprint_path(sprint)

        click_on 'Manage'

        

      end
    end

    describe "removing a ticket" do
      it "should be removed"
    end

    describe "updating holidays" do
      it "should reduce the amount of available effort"
    end

    describe "updating associated tickets" do
      it "should update accordingly"
    end
  end

  describe "updating ticket effort" do
    it "should update the record"
  end

  describe "adding a note to a ticket" do
    it "should update the record"
  end

  context "finishing a sprint" do
    describe "when the end date is reached" do
      it "should close the sprint"
    end

    describe "when a sprint is closed early" do
      it "should close the sprint"
    end
  end
end