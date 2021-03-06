# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams', type: :feature do
  include AuthHelper

  before(:each) do
    log_in
  end

  describe 'viewing a team' do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }

    it 'should list the sprints' do
      visit team_path(team)

      expect(page).to have_content sprint.name
    end
  end

  describe 'adding a team with valid data' do
    let!(:user) { create(:user) }

    it 'should create the team' do
      visit teams_path

      click_on 'Add Team'

      fill_in 'Name', with: 'test'
      check user.name

      click_on 'Create Team'

      expect(page).to have_content 'test'
    end
  end

  describe 'adding a team with invalid data' do
    let!(:user) { create(:user) }

    it 'should not create the team' do
      visit teams_path

      click_on 'Add Team'

      check user.name

      click_on 'Create Team'

      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  context 'Goal status' do
    context 'When a sprint is in progress' do
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each { |t| sprint.sprint_tickets.create(t.attributes) } }

      describe 'and the goal is yet to be met' do
        it "should show the status 'in progress'" do
          sprint.update(finish_by: sprint.start_date + 2.days,
                        initial_ticket_ids: sprint_tickets.pluck(:id))

          visit team_path(team)

          expect(page).to have_content 'In Progress'
        end
      end

      describe 'and the goal is met after the finish by date' do
        it "should show the status 'goal met'" do
          sprint.update(finish_by: sprint.start_date + 2.days,
                        initial_ticket_ids: sprint_tickets.pluck(:id))
          sprint.sprint_tickets.update_all(closed_at: sprint.end_date)

          visit team_path(team)

          expect(page).to have_content 'Goal Met'
        end
      end

      describe 'and the goal is met before the finish by date' do
        it "should show the status 'goal met early'" do
          sprint.update(finish_by: sprint.start_date + 2.days,
                        initial_ticket_ids: sprint_tickets.pluck(:id))
          sprint.sprint_tickets.update_all(closed_at: sprint.start_date)

          visit team_path(team)

          expect(page).to have_content 'Goal Met Early'
        end
      end
    end

    context 'When a sprint is finished' do
      let!(:tickets) { create_list(:ticket, 5, state: 'open') }
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint, team: team) }
      let!(:sprint_tickets) { tickets.each { |t| sprint.sprint_tickets.create(t.attributes) } }

      describe "and the goal wasn't met" do
        it "should show the status 'goal not met'" do
          sprint.update(closed_at: sprint.end_date, initial_ticket_ids: sprint_tickets.pluck(:id))

          visit team_path(team)

          expect(page).to have_content 'Goal Not Met'
        end
      end

      describe 'and the goal was met' do
        it "should show the status 'goal met'" do
          sprint.update(closed_at: sprint.end_date, initial_ticket_ids: sprint_tickets.pluck(:id))
          sprint.sprint_tickets.update_all(closed_at: sprint.end_date)

          visit team_path(team)

          expect(page).to have_content 'Goal Met'
        end
      end
    end
  end

  context 'Velocity status' do
    let!(:tickets) { create_list(:ticket, 5, state: 'open') }
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { tickets.each { |t| sprint.sprint_tickets.create(t.attributes) } }

    describe 'when the velocity meets the initial effort' do
      it "should show the status 'initial effort met'" do
        sprint.update(initial_ticket_ids: sprint_tickets.pluck(:id))
        sprint.sprint_tickets.update_all(closed_at: sprint.end_date)

        visit team_path(team)

        expect(page).to have_content 'Initial Effort Met'
      end
    end

    describe 'when the velocity exceeds the initial effort' do
      it "should show the status 'overdelivered'" do
        sprint.update(initial_ticket_ids: sprint_tickets.pluck(:id))
        sprint.sprint_tickets.update_all(closed_at: sprint.end_date)

        additional_tickets = create_list(:ticket, 5, state: 'open')
        additional_tickets.each do |t|
          sprint.sprint_tickets.create(t.attributes.merge({ closed_at: Date.today }))
        end

        visit team_path(team)

        expect(page).to have_content 'Overdelivered'
      end
    end

    describe 'when the velocity does not meet the initial effort' do
      it "should show the status 'initial effort not met'" do
        sprint.update(initial_ticket_ids: sprint_tickets.pluck(:id))
        sprint.sprint_tickets.first.update(closed_at: sprint.end_date)

        visit team_path(team)

        expect(page).to have_content 'Initial Effort Not Met'
      end
    end
  end
end
