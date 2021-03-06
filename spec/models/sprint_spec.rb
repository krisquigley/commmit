# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sprint, type: :model do
  context 'total_estimated_effort' do
    describe 'sprint locked and loaded' do
      let!(:team) { create(:team) }
      let!(:sprint) do
        create(:sprint_with_tickets, start_date: '2000-1-1', end_date: '2000-1-7', team: team)
      end

      it 'should total all estimated effort for associated sprint tickets' do
        sprint.update(initial_ticket_ids: sprint.sprint_tickets.pluck(:id))
        total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+)

        expect(sprint.total_estimated_effort).to eq(total_estimated_effort)
      end
    end

    describe 'sprint not locked and loaded' do
      let!(:team) { create(:team) }
      let!(:sprint) do
        create(:sprint_with_tickets, start_date: '2000-1-1', end_date: '2000-1-7', team: team)
      end

      it 'should total all estimated effort for associated sprint tickets' do
        expect(sprint.total_estimated_effort).to eq(0)
      end
    end
  end

  describe 'velocity' do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it 'should be effort of all closed tickets' do
      ticket = sprint.sprint_tickets.first
      ticket.update(closed_at: Date.today)
      expect(sprint.velocity).to eq(ticket.estimated_effort)
    end
  end

  describe 'final_velocity' do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it 'should get set once a sprint is finished' do
      sprint.sprint_tickets.update_all(closed_at: DateTime.now)
      sprint.update(closed_at: DateTime.now)

      expect(sprint.final_velocity).to eq sprint.velocity
    end
  end

  describe 'no_of_members' do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it 'should get set once a sprint is created' do
      sprint.sprint_tickets.update_all(closed_at: DateTime.now)
      sprint.update(closed_at: DateTime.now)

      expect(sprint.no_of_members).to eq sprint.team.users.count
    end
  end

  describe 'days_off' do
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it 'should set the days_off to 0.0' do
      expect(sprint.days_off).to eq 0.0
    end
  end
end
