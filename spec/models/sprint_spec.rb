require 'rails_helper'

RSpec.describe Sprint, type: :model do
  describe "total_estimated_effort" do
    let(:users) { create_list(:user, 2) }
    let!(:sprint) { create(:sprint_with_tickets, start_date: '2000-1-1', end_date: '2000-1-7', users: users) }

    it "should total all estimated effort for associated sprint tickets" do
      total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+)

      expect(sprint.total_estimated_effort).to eq(total_estimated_effort)
    end 
  end

  describe "velocity" do
    let(:users) { create_list(:user, 2) }
    let!(:sprint) { create(:sprint_with_tickets, users: users) }

    it "should be effort of all closed tickets" do
      ticket = sprint.sprint_tickets.first
      ticket.update(closed_at: Date.today)
      expect(sprint.velocity).to eq(ticket.estimated_effort)
    end
  end

  describe "effort_to_date" do
    let(:users) { create_list(:user, 2) }
    let!(:sprint) { create(:sprint_with_tickets, users: users) }

    it "should calculate how much effort has been used up to today" do
      # 5 work days have passed since the start of the sprint
      tickets = sprint.sprint_tickets.all.limit(2)
      tickets.update_all(closed_at: Time.now)
      total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+)

      effort_to_date = total_estimated_effort - tickets.pluck(:estimated_effort).reduce(:+)

      # Returns a JSON array of the 8 days that have passed since the start of the sprint
      expect(sprint.effort_to_date).to eq([
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
