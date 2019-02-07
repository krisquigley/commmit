require "rails_helper"

RSpec.describe "Creating a ticket" do 
  describe "with a valid payload", sidekiq: :inline, type: :request  do
    let(:new_issue_payload) { file_fixture("opened_issue_with_estimation_payload.json").read }
    
    before do
      post '/tickets', params: new_issue_payload, headers: { "Content-Type"  => "application/json" }
    end

    it "should create a new ticket" do
      expect(Ticket.count).to eq(1)
      expect(response).to have_http_status(202)
    end
  end
end