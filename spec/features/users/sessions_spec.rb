require 'rails_helper'

RSpec.describe "Logging in", type: :feature do
  include AuthHelper

  before(:each) do
    log_in
    sign_up
  end

  context "with the correct details" do
    it "should redirect to the account page" do
      visit new_user_session_path
      user = User.first

      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'testing'

      click_on 'Log in'

      expect(page).to have_content user.name
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

  before(:each) do
    log_in
    sign_up
  end

  it "should redirect to the sign in page"
end