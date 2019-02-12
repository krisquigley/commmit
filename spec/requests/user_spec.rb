require 'rails_helper'

RSpec.describe "Users", sidekiq: :inline, type: :request do
  describe "adding a new user" do
    let(:new_user_payload) { file_fixture("new_user_payload.json").read }
    
    before do
      post '/webhooks/members', params: new_user_payload, headers: { "Content-Type"  => "application/json" }
    end

    it "should add a user to the db" do
      expect(User.count).to eq(1)
      expect(response).to have_http_status(202)
    end
  end

  describe "updating a user" do
    let!(:user) { create(:user, github_user_id: 583231) }
    let(:edited_user_payload) { file_fixture("edited_user_payload.json").read }

    
    before do
      post '/webhooks/members', params: edited_user_payload, headers: { "Content-Type"  => "application/json" }
    end

    it "should add a user to the db" do
      expect(user.reload.name).to eq('octodog')
      expect(response).to have_http_status(202)
    end
  end
end