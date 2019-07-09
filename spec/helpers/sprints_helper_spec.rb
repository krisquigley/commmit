require 'rails_helper'

RSpec.describe SprintsHelper do
  describe "#effort_to_date" do
    let!(:department) { create(:department_with_teams) }
    let!(:sprint) { create(:sprint_with_tickets, team: department.teams.first) }

    it "should calculate how much effort has been used up to today" do
      # 5 work days have passed since the start of the sprint
      tickets = sprint.sprint_tickets.all.limit(2)
      tickets.update_all(closed_at: Time.now)
      total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+)

      effort_to_date = total_estimated_effort - tickets.pluck(:estimated_effort).reduce(:+)

      # Returns a JSON array of the 8 days that have passed since the start of the sprint
      expect(helper.effort_to_date(sprint)).to eq([
        total_estimated_effort,
        total_estimated_effort,
        total_estimated_effort,
        total_estimated_effort,
        total_estimated_effort,
        total_estimated_effort,
        total_estimated_effort,
        effort_to_date
      ].to_json)
    end
  end
end