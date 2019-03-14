require 'rails_helper'

RSpec.describe Sprint, type: :model do
  describe "creating a sprint" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it "should create holiday records" do
      expect(sprint.sprint_holidays.count).to eq(team.users.count)
    end
  end

  describe "available_effort_after_review_time" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, start_date: '2000-1-1', end_date: '2000-1-7', team: team) }

    it "should take into account sprint holidays" do
      # All users * 5 work days - 20% reviewing tickets - 5 days for holiday
      sprint.sprint_holidays.first.update(days: 5)
      available_effort = ((team.users.count * 5) - 5) * 0.8

      expect(sprint.available_effort_after_review_time).to eq(available_effort)
    end
  end

  describe "total_estimated_effort" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, start_date: '2000-1-1', end_date: '2000-1-7', team: team) }

    it "should total all estimated effort for associated sprint tickets" do
      total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+) 

      expect(sprint.total_estimated_effort).to eq(total_estimated_effort)
    end 
  end

  describe "effort_remaining" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it "should be available_effort_after_review_time - total_estimated_effort" do
      expect(sprint.effort_remaining).to eq(sprint.available_effort_after_review_time - sprint.total_estimated_effort)
    end
  end

  describe "effort_to_date" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

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
