require 'rails_helper'

RSpec.describe "Dashboard", type: :feature do
  include AuthHelper

  before(:each) do
    log_in
  end

  describe "Viewing the dashboard" do
    it "should show the dashboard" do
      create_list(:closed_and_assigned_tickets, 5)

      visit dashboard_path

      expect(page).to have_content 5
    end
  end
end