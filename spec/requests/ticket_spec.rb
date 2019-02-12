require "rails_helper"

RSpec.describe "Tickets", sidekiq: :inline, type: :request do 
  describe "when a new ticket is added" do
    let(:new_issue_payload) { file_fixture("opened_issue_with_estimation_payload.json").read }
    
    before do
      post '/webhooks/issues', params: new_issue_payload, headers: { "Content-Type"  => "application/json" }
    end

    it "should create a new ticket" do
      expect(Ticket.count).to eq(1)
      expect(response).to have_http_status(202)
    end
  end

  describe "when a ticket is closed" do
    let!(:ticket) { create(:ticket, issue_id: 406911947) }
    let(:edited_issue_payload) { file_fixture("edited_issue_payload.json").read }
    
    before do
      post '/webhooks/issues', params: edited_issue_payload, headers: { "Content-Type"  => "application/json" }
    end

    it "should update the ticket" do
      expect(ticket.reload.title).to eq("[2] new issue")
      expect(response).to have_http_status(202)
    end
  end

  describe "when a ticket has assignees" do
    let!(:user1) { create(:user, github_user_id: 1234) }
    let!(:user2) { create(:user, github_user_id: 4321) }

    let(:new_issue_payload) { file_fixture("opened_issue_with_assignees_payload.json").read }

    before do
      post '/webhooks/issues', params: new_issue_payload, headers: { "Content-Type"  => "application/json" }
    end

    # This test should be used to check SprintTickets are associated correctly
    xit "should belong to both users" do
      expect(Ticket.first.users.count).to eq(2)
      expect(user1.reload.tickets.count).to eq(1)
      expect(user2.reload.tickets.count).to eq(1)
    end
  end
end