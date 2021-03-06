# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SprintTicket, type: :model do
  describe 'when a sprint ticket has assignees' do
    let!(:user1) { create(:user, github_user_id: 1234) }
    let!(:user2) { create(:user, github_user_id: 4321) }
    let(:sprint_ticket) do
      create(:sprint_ticket, github_user_ids: [user1.github_user_id, user2.github_user_id])
    end

    it 'should belong to both users' do
      expect(sprint_ticket.users.count).to eq(2)
      expect(user1.reload.sprint_tickets.count).to eq(1)
      expect(user2.reload.sprint_tickets.count).to eq(1)
    end
  end
end
