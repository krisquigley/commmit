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
    describe "searching for a ticket" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should return the right results" do
        visit manage_sprint_path(sprint)

        fill_in "search", with: tickets.first.title.split(' ')[0]

        click_on 'Filter'

        expect(page).to have_content tickets.first.title
        expect(page).to_not have_content tickets.last.title
      end
    end
  
    describe "filtering by repo" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should return the right tickets" do
        visit manage_sprint_path(sprint)

        select tickets.first.repository_name, from: 'repository_name'

        click_on 'Filter'

        expect(page).to have_content tickets.first.title
        expect(page).to_not have_content tickets.last.title
      end
    end

    describe "adding a ticket", js: true do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }

      it "should be added" do
        create(:ticket)

        visit sprint_path(sprint)

        click_on 'Manage'

        click_on 'Add'

        within("[data-behavior='assignedTickets']") do
          expect(page).to have_content(Ticket.first.title)
        end
        expect(sprint.sprint_tickets.count).to eq(1)
      end
    end

    describe "removing a ticket", js: true do
      let(:user) { create(:user) }
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes.except("source")) } }

      it "should be removed" do
        visit sprint_path(sprint)

        click_on 'Manage'

        expect(sprint.sprint_tickets.count).to eq(5)
        
        within("tbody[data-behavior='assignedTickets']") do
          find("button[data-behavior='removeTicket']", match: :first).click
        end
        sleep 1
        expect(sprint.reload.sprint_tickets.count).to eq(4)
      end
    end

    describe "updating holidays" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team, start_date: '2019-03-04', end_date: '2019-03-08') }

      it "should reduce the amount of available effort" do
        visit sprint_path(sprint)

        # 1 user, 5 days of effort, 20% spent on reviewing
        expect(page).to have_content("4")

        click_on "Manage"

        fill_in "sprint_sprint_holidays_attributes_0_days", with: 1.5
        click_on "Update Sprint"

        expect(page).to have_content("2")
      end
    end

    describe "updating associated tickets" do
      let(:user) { create(:user) }
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes.except("source")) } }

      it "should show when it was closed" do
        time = Time.now
        sprint.sprint_tickets.first.update(closed_at: time)
        
        visit sprint_path(sprint)

        expect(page).to have_content(time.to_date.to_formatted_s(:long))
      end

      it "should show who is assigned" do
        sprint.sprint_tickets.last.update(github_user_ids: [user.github_user_id])

        visit sprint_path(sprint)

        expect(page).to have_content(user.name)
      end
    end
  end

  describe "updating estimated ticket effort", js: true do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { create_list(:sprint_ticket, 5, sprint: sprint) }

    it "should update the record" do
      visit sprint_path(sprint)

      find("input[data-behavior='updateEstimatedEffort'][data-issueid='#{sprint_tickets.first.issue_id}']").set(3.2).send_keys(:tab)

      sleep 1

      expect(sprint_tickets.first.reload.estimated_effort).to eq 3.2
    end
  end

  describe "updating ticket effort", js: true do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { create_list(:sprint_ticket, 5, sprint: sprint) }

    it "should update the record" do
      visit sprint_path(sprint)

      find("input[data-behavior='updateEffort'][data-issueid='#{sprint_tickets.first.issue_id}']").set(4.5).send_keys(:tab)

      sleep 1
      
      expect(sprint_tickets.first.reload.actual_effort).to eq 4.5
    end
  end

  describe "adding a note to a ticket", js: true do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { create_list(:sprint_ticket, 5, sprint: sprint) }

    it "should update the record" do
      visit sprint_path(sprint)

      find("textarea[data-behavior='updateNote'][data-issueid='#{sprint_tickets.first.issue_id}']").set('This is a note').send_keys(:tab) 

      sleep 1
      
      expect(sprint_tickets.first.reload.notes).to eq 'This is a note'
    end
  end


  context "finishing a sprint" do
    describe "when the end date is reached" do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team, end_date: Date.today) }

      it "should close the sprint" do
        visit sprints_path

        expect(page).to have_content('In Progress')

        sprint.update(end_date: Date.today - 1)

        visit sprints_path

        expect(page).to have_content('Finished')
      end
    end

    describe "when a sprint is closed early", js: true do
      let(:user) { create(:user) }
      let!(:team) { create(:team, user_ids: user.id) }
      let!(:sprint) { create(:sprint, team: team) }

      it "should close the sprint" do
        visit sprint_path(sprint)

        click_on 'Close Sprint'
        page.accept_alert

        expect(page).to have_content('Finished')

        visit sprint_path(sprint)

        expect(page).to_not have_content('In Progress')
        expect(page).to_not have_content('Manage')
        expect(page).to_not have_content('Close Sprint')
      end
    end
  end
end