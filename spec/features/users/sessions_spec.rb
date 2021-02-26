require 'rails_helper'

RSpec.describe "Logging in", type: :feature do
  include AuthHelper

  context "with the correct details" do
    it "should redirect to the account page" do
      visit new_user_session_path
      user = User.first

      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'testing123'

      click_on 'Log in'

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content user.username
    end
  end

  context "with incorrect details" do
    it "should raise an error" do
      visit new_user_session_path

      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end

RSpec.describe "Logging out", type: :feature do
  include AuthHelper

  it "should redirect to the sign in page" do
    log_in
    visit dashboard_path
    click_on 'Log out'
    
    expect(page).to have_current_path(new_user_session_path)
  end
end