require 'rails_helper'

RSpec.describe TeamsHelper do
  describe "#happiness_values" do
    # TODO: refactor to use different factories
    # Set up a sprint with 3 people
    # Set up retro with team and company happiness values
    let!(:department_with_teams) { create(:department_with_teams) }
    let!(:sprint_with_tickets) do
      user = create(:user) 
      department_with_teams.teams.first.users << user 
      sprint_with_tickets = create(:sprint_with_tickets, team: department_with_teams.teams.first, start_date: '2019-01-01', end_date: '2019-01-05')
      sprint_with_tickets.update(closed_at: '2019-01-05')
      sprint_with_tickets.team.users.each do |user|
        sprint_with_tickets.retrospectives.create!(user: user, role_happiness: 1, company_happiness: 4, feedback: 'test', happiness_goal: 'test')
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

    let(:sprints) { [sprint_with_tickets, sprint_with_tickets_2].flatten }

    it "should return json in the correct format" do
      expect(helper.happiness_values(sprints)).to eq "[{\"end_date\":\"2019-01-05T00:00:00.000Z\",\"average_happiness\":2.5},{\"end_date\":\"2019-01-12T00:00:00.000Z\",\"average_happiness\":3.3}]" 
    end
  end

  describe "#velocity" do
    let!(:department) { create(:department_with_teams) }
    # TODO: refactor
    let!(:closed_sprints_with_closed_tickets) do 
      create_list(:sprint_with_closed_tickets, 5, team: department.teams.first)
      create(:sprint_with_closed_tickets, team: department.teams.first, end_date: Date.today.advance(months: +2))
      sprints = Sprint.all
      sprints.each { |s| s.update(closed_at: Time.now) }
      Sprint.order(end_date: :desc)
    end

    it "should return final velocity and end date in json" do
      expectation = Sprint.order(end_date: :desc).first
      expect(helper.velocity(closed_sprints_with_closed_tickets)).to be_a String
      expect(JSON.parse(helper.velocity(closed_sprints_with_closed_tickets)).last).to eq(
        { "end_date" => expectation.end_date.strftime('%Y-%m-%dT%H:%M:%S.%LZ'), "final_velocity" => expectation.velocity.to_f.round(1).to_s, "id" => nil }
      )
    end
  end

  describe "#no_of_members_per_sprint" do
    let!(:department) { create(:department_with_teams) }
    let!(:closed_sprints_with_closed_tickets) do 
      create_list(:sprint_with_closed_tickets, 4, team: department.teams.first)
      user = create(:user)
      department.teams.first.users << user
      create(:sprint_with_tickets, team: department.teams.first, end_date: Time.now.advance(months: +2))
      Sprint.order(end_date: :desc)
    end

    it "should return an array in json" do
      expect(helper.no_of_members_per_sprint(closed_sprints_with_closed_tickets)).to eq "[2,2,2,2,3]"
    end
  end

  describe "#velocity_per_person_per_day_per_sprint" do
    let!(:department) { create(:department_with_teams) }
    let!(:closed_sprints_with_closed_tickets) do 
      create_list(:sprint_with_closed_tickets, 5, team: department.teams.first)
      sprints = Sprint.all
      sprints.each { |s| s.update(closed_at: Time.now) }
      Sprint.order(end_date: :desc)
    end

    it "should return an array in json" do
      expect(helper.velocity_per_person_per_day_per_sprint(closed_sprints_with_closed_tickets)).to be_a String
      
      expectation = Sprint.order(end_date: :desc).first.velocity / (department.teams.first.users.count * 5.0)
      expect(JSON.parse(helper.velocity_per_person_per_day_per_sprint(closed_sprints_with_closed_tickets)).last).to eq expectation.round(2).to_s
    end
  end
end