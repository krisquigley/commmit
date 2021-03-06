# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe ExportSprintToCsvJob, sidekiq: :inline do
  describe 'exporting a sprint to csv' do
    let(:user) { create(:user) }
    let!(:tickets) { create_list(:ticket, 5, state: 'open') }
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }

    it 'should save the string to redis' do
      tickets.each { |t| sprint.sprint_tickets.create(t.attributes) }
      uuid = SecureRandom.uuid

      described_class.perform_async(sprint.slug, uuid)
      redis = Redis.new
      expect(redis.get(uuid)).to eq ExportSprintToCsv.call(sprint.slug)
    end
  end
end
