# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'yesterdays weather' do
    context 'with 4 previous sprints' do
      let!(:team) { create(:team) }
      let!(:sprint1) { create(:sprint_with_tickets, team: team) }
      let!(:sprint2) { create(:sprint_with_tickets, team: team) }
      let!(:sprint3) { create(:sprint_with_tickets, team: team) }
      let!(:sprint4) { create(:sprint_with_tickets, team: team) }
      let!(:sprint5) { create(:sprint_with_tickets, team: team) }

      it 'should calculate the average velocity of at most 3 previous sprints' do
        sprint1.sprint_tickets.update_all(closed_at: DateTime.now)
        sprint1.update(closed_at: DateTime.now)

        sprint2.sprint_tickets.update_all(closed_at: DateTime.now)
        sprint2.update(closed_at: DateTime.now)

        sprint3.sprint_tickets.update_all(closed_at: DateTime.now)
        sprint3.update(closed_at: DateTime.now)

        sprint4.sprint_tickets.update_all(closed_at: DateTime.now)
        sprint4.update(closed_at: DateTime.now)

        sprint5.sprint_tickets.update_all(closed_at: DateTime.now)

        expect(team.yesterdays_weather)
          .to eq((sprint4.velocity + sprint3.velocity + sprint2.velocity) / 3)
      end
    end

    context 'with 1 previous sprint' do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint_with_tickets, team: team) }

      it 'should calculate the average velocity of the previous sprint' do
        sprint.sprint_tickets.update_all(closed_at: DateTime.now)
        sprint.update(closed_at: DateTime.now)

        expect(sprint.team.yesterdays_weather).to eq sprint.velocity
      end
    end

    context 'with 0 previous sprints' do
      let!(:team) { create(:team) }
      let!(:sprint) { create(:sprint_with_tickets, team: team) }

      it 'should return 0' do
        expect(sprint.team.yesterdays_weather).to eq 0
      end
    end
  end
end
