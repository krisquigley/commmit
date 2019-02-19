require 'rails_helper'

RSpec.describe SprintTicket, type: :model do
  context "determining closed_at" do
    describe "when closed_at is nil" do
      let(:sprint_ticket) { build(:sprint_ticket) }

      it "should return Unmerged" do
        expect(sprint_ticket.closed_at_formatted).to eq('Open')
      end
    end

    describe "when closed_at is not nil" do
      let!(:time) { Time.now }
      let(:sprint_ticket) { build(:sprint_ticket, closed_at: time) }

      it "should return the correct value" do
        expect(sprint_ticket.closed_at_formatted).to eq(time.to_date.to_formatted_s(:long))
      end
    end
  end

  describe "when a sprint ticket has assignees" do
    let!(:user1) { create(:user, github_user_id: 1234) }
    let!(:user2) { create(:user, github_user_id: 4321) }
    let(:sprint_ticket) { create(:sprint_ticket, github_user_ids: [user1.github_user_id, user2.github_user_id]) }

    it "should belong to both users" do
      expect(sprint_ticket.users.count).to eq(2)
      expect(user1.reload.sprint_tickets.count).to eq(1)
      expect(user2.reload.sprint_tickets.count).to eq(1)
    end
  end
end