# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportSprintToCsv do
  describe 'exporting a sprint to csv' do
    let(:user) { create(:user) }
    let!(:tickets) { create_list(:ticket, 5, state: 'open') }
    let!(:team) { create(:team) }
    let!(:sprint) { create(:sprint, team: team) }
    let!(:sprint_tickets) { tickets.each { |t| sprint.sprint_tickets.create(t.attributes) } }

    it 'should return a string' do
      export = ExportSprintToCsv.call(sprint.slug)
      expect(export).to be_a_kind_of(String)
    end
  end
end
