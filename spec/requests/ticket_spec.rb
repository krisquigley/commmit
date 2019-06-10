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

  context "active sprints" do
    describe "when a ticket is updated" do
      let!(:ticket) { create(:ticket, issue_id: 406911947) }
      let(:edited_issue_payload) { file_fixture("edited_issue_payload.json").read }
      let!(:department) { create(:department_with_teams) }
      let!(:active_sprint) { create(:sprint, team: department.teams.first) }
      let!(:inactive_sprint) { create(:sprint, team: department.teams.first, start_date: 2.weeks.ago, end_date: 1.week.ago) }
      let!(:sprint_ticket1) { create(:sprint_ticket, issue_id: 406911947, sprint: active_sprint) }
      let!(:sprint_ticket2) { create(:sprint_ticket, issue_id: 406911947, sprint: inactive_sprint) }
      
      before do
        post '/webhooks/issues', params: edited_issue_payload, headers: { "Content-Type"  => "application/json" }
      end
  
      it "should only update the active sprint" do
        expect(ticket.reload.title).to eq("[2] new issue")
        expect(sprint_ticket1.reload.title).to eq("[2] new issue")
        expect(sprint_ticket2.reload.title).to_not eq("[2] new issue")
      end
    end
  end
end