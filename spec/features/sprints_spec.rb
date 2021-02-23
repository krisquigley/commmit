require "rails_helper"

RSpec.describe "Sprints", type: :feature do
  include AuthHelper
  
  before(:each) do
    log_in
  end

  context "creating a sprint" do
    let!(:team) { create(:team) }

    describe "with valid data" do
      it "should create the sprint" do
        visit new_team_sprint_path(team)

        fill_in 'Goal', with: 'Test'
        fill_in 'Start date', with: '01/01/2000'
        fill_in 'End date', with: '20/01/200'

        click_on 'Create Sprint'

        expect(page).to have_content('Test')
      end
    end

    describe "with invalid data" do
      it "should raise an error" do
        visit new_team_sprint_path(team)

        fill_in 'Start date', with: ''
        fill_in 'End date', with: ''
        
        click_on 'Create Sprint'

        expect(page).to have_content("Name can't be blank Start date can't be blank End date can't be blank")
      end
    end
  end
  
  context "managing a sprint" do
    describe "searching for a ticket" do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should return the right results" do
        visit manage_sprint_path(sprint)

        fill_in "search", with: tickets.first.title

        click_on 'Filter'

        expect(page).to have_content tickets.first.title
        expect(page).to_not have_content tickets.last.title
      end
    end

    describe "updating days off" do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }

      it "should return the right results" do
        visit manage_sprint_path(sprint)

        click_on 'Settings'

        fill_in "Days off", with: 2.5

        click_on "Update Sprint"

        expect(sprint.reload.days_off).to eq 2.5
      end
    end

    describe "setting finish by", js: true do
      let!(:team) { create(:team_with_users) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:tickets) { create_list(:ticket, 5) }
      let!(:sprint_tickets) do 
        tickets.each {|t| sprint.sprint_tickets.create(t.attributes.except("id")) }
        sprint.sprint_tickets
      end

      it "should return the right results" do
        visit manage_sprint_path(sprint)

        fill_in "Finish Sprint early by", with: sprint.end_date - 2.days
        click_on "Lock & Load"
        sleep 1

        expect(page).to have_content 'Sprint Locked and Loaded!'
        
        initial_tickets = sprint.sprint_tickets.pluck(:id)

        additional_tickets = create_list(:ticket, 5)
        additional_tickets.each { |t| sprint.sprint_tickets.create(t.attributes.except("id")) }
        
        expect(sprint.reload.finish_by).to eq(sprint.end_date - 2.days)
        expect(sprint.reload.initial_ticket_ids).to match_array(initial_tickets)
      end
    end
  
    describe "filtering by repo" do
      let!(:team) { create(:team) }
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
      let!(:team) { create(:team) }
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
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes.except("id")) } }

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

      context "when a sprint is locked and loaded" do
        it "should not be able to remove tickets" do
          visit sprint_path(sprint)

          click_on 'Manage'

          click_on 'Lock & Load'
          
          click_on 'Manage'

          expect(page).to have_button('Remove', disabled: true)
        end
      end
    end

    describe "updating associated tickets" do
      let(:user) { create(:user) }
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes) } }

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

  describe "adding a note to a ticket", js: true do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { create_list(:sprint_ticket, 5, sprint: sprint) }

    it "should update the record" do
      visit sprint_path(sprint)

      find("textarea[data-id='#{sprint_tickets.first.id}']").set('This is a note').send_keys(:tab) 
      sleep 1
      expect(sprint_tickets.first.reload.notes).to eq 'This is a note'
    end
  end

  describe "exporting sprint to CSV", js: true, sidekiq: :inline do
    let(:user) { create(:user) }
    let!(:tickets) { create_list(:ticket, 5, state: 'open') }
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes) } }

    it "should update the record" do
      visit sprint_path(sprint)

      click_on 'Export to CSV'

      within "#exportToCSV" do
        click_on "Generate CSV for current Sprint"
        sleep 1
        expect(page).to have_link "Download CSV for current Sprint"
      end
    end
  end


  context "finishing a sprint" do
    describe "when a sprint is closed early", js: true do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }

      it "should close the sprint" do
        visit sprint_path(sprint)

        click_on 'Close Sprint'
        sleep 1
        within "form[action='#{sprint_path(sprint)}']" do
          fill_in "Days off", with: 5
          click_on 'Close Sprint'
        end

        expect(page).to have_content('Retrospective Feedback')
        expect(page).to_not have_content('Manage')
        expect(page).to_not have_content('Close Sprint')
        expect(sprint.reload.days_off).to eq 5
      end
    end

    describe "leaving feedback on sprint retro", js: true do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }

      it "should be valid" do
        visit sprint_retrospective_path(sprint)

        fill_in 'What went well and how did it go well?', with: "some things"
        fill_in 'What can be better?', with: "some other things"
        fill_in 'How can we go faster next sprint?', with: "this thing"

        click_on 'Submit Feedback'

        visit sprint_retrospective_path(sprint)

        expect(page).to have_content "some things"
        expect(page).to have_content "this thing"
        expect(page).to have_content "some other things"
      end
    end
  end
end