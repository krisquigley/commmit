require 'rails_helper'

RSpec.describe "Dashboard", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "Viewing the dashboard" do
    it "should show the dashboard" do
      create_list(:closed_tickets, 5)

      visit dashboard_path
    end
  end
end