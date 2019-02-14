require 'rails_helper'

RSpec.describe "Users", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "viewing users" do
    let!(:users) { create_list(:user, 5) }
    let!(:team) { create(:team, user_ids: users.first.id) }
    
    it "should list the users and their teams" do
      visit users_path
      users.each do |user|
        expect(page).to have_content(user.name)
      end
      expect(page).to have_content(team.name)
    end
  end
end
