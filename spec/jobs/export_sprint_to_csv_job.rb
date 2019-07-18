require "rails_helper"
require "securerandom"

RSpec.describe ExportSprintToCsvJob, sidekiq: :inline do
  describe "exporting a sprint to csv" do
    let(:user) { create(:user) }
    let!(:tickets) { create_list(:ticket, 5, state: 'open') }
    let!(:department) { create(:department_with_teams) }
    let!(:sprint) { create(:sprint, team: department.teams.first) }
    let!(:sprint_tickets) { tickets.each {|t| sprint.sprint_tickets.create(t.attributes) } }
    let!(:uuid) { SecureRandom.uuid }

    it "should save the string to redis" do
      ExportSprintToCsvJob.perform_async(sprint.slug, uuid)
      redis = Redis.new
      expect(redis.get(uuid)).to eq ExportSprintToCsv.call(sprint.slug)
    end
  end
end