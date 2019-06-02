require "rails_helper"

RSpec.describe "Retrospectives", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end

  describe "viewing sprint feedback for a sprint" do
    it "should show happiness values"
    
    it "should show feedback"
  end

  context "adding feedback to a sprint" do
    describe "with valid data", js: true do
      let(:users) { create_list(:user, 2) }
      let!(:sprint) { create(:sprint, users: users) }
      let!(:tickets) { create_list(:ticket, 5) }
      
      it "should get added" do
        visit sprint_path(sprint)

        click_on 'Close Sprint'
        page.accept_alert
        click_on 'Retrospective Feedback'

        fill_in 
        
      end
    end

    describe "with invalid data" do
      it "should not get added"
    end
  end
end