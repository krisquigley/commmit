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
      # All users * 5 work days - 20% reviewing tickets
      total_estimated_effort = SprintTicket.all.pluck(:estimated_effort).reduce(:+) 

      expect(sprint.total_estimated_effort).to eq(total_estimated_effort)
    end 
  end

  describe "effort_used" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it "should calculate actual effort used in total across the sprint" do
      actual_effort = 6
      sprint.sprint_tickets.first.update(closed_at: Time.now, actual_effort: actual_effort)
  
      expect(sprint.effort_used).to eq(actual_effort)
    end
  end

  describe "effort_remaining" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it "should be available_effort_after_review_time - effort_used" do
      actual_effort = 6
      sprint.sprint_tickets.first.update(closed_at: Time.now, actual_effort: actual_effort)
  
      expect(sprint.effort_remaining).to eq(sprint.available_effort_after_review_time - actual_effort)
    end
  end

  describe "effort_to_date" do
    let(:user) { create(:user) }
    let!(:team) { create(:team, user_ids: user.id) }
    let!(:sprint) { create(:sprint_with_tickets, team: team) }

    it "should calculate how much effort has been used to up today" do
      # 5 work days have passed since the start of the sprint
      ticket = sprint.sprint_tickets.first
      ticket.update(closed_at: Time.now)

      effort_to_date = sprint.available_effort_after_review_time - ticket.estimated_effort

      # Returns a JSON array of the 8 days that have passed since the start of the sprint
      expect(sprint.effort_to_date).to eq([
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        sprint.available_effort_after_review_time,
        effort_to_date
      ].to_json)
    end
  end
end
