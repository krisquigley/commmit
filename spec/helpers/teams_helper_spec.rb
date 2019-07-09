require 'rails_helper'

RSpec.describe TeamsHelper do
  describe "#happiness_values" do
    # Set up a sprint with 3 people
    # Set up retro with team and company happiness values
    let!(:department_with_teams) { create(:department_with_teams) }
    let!(:sprint_with_tickets) do
      user = create(:user) 
      department_with_teams.teams.first.users << user 
      sprint_with_tickets = create(:sprint_with_tickets, team: department_with_teams.teams.first, start_date: '2019-01-01', end_date: '2019-01-05')
      sprint_with_tickets.update(closed_at: '2019-01-05')
      sprint_with_tickets.team.users.each do |user|
        sprint_with_tickets.retrospectives.create!(user: user, role_happiness: 1, team_happiness: 2, company_happiness: 4, feedback: 'test', happiness_goal: 'test')
      end
      sprint_with_tickets
    end

    # Set up a sprint with 4 people
    # Set up retro with all happiness values
    let!(:sprint_with_tickets_2) do
      sprint_with_tickets = create(:sprint_with_tickets, team: department_with_teams.teams.first, start_date: '2019-01-08', end_date: '2019-01-12')
      sprint_with_tickets.update(closed_at: '2019-01-12')
      sprint_with_tickets.team.users.each do |user|
        sprint_with_tickets.retrospectives.create!(user: user, role_happiness: 3, team_happiness: 5, company_happiness: 2, feedback: 'test', happiness_goal: 'test')
      end
      # Add another user which does not have a retro
      user_2 = create(:user) 
      department_with_teams.teams.first.users << user_2
      sprint_with_tickets
    end

    let!(:happiness) { Retrospective.retros_with_end_dates([sprint_with_tickets.id, sprint_with_tickets_2.id]) }

    it "should return json in the correct format" do
      expect(helper.happiness_values(happiness)).to eq "[{\"end_date\":\"2019-01-05T00:00:00.000Z\",\"average_happiness\":2.3},{\"end_date\":\"2019-01-12T00:00:00.000Z\",\"average_happiness\":3.3}]" 
    end
  end
end