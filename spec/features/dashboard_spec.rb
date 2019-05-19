require "rails_helper"

RSpec.describe "Dashboard ", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end

  describe "view sprint overview" do
    it "should render the page" do
      visit dashboard_path

      expect(page).to have_content "dashboard"
    end
  end
end