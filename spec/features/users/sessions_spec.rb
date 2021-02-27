require 'rails_helper'

RSpec.describe "Logging in", type: :feature do
  include AuthHelper

  context "with the correct details" do
    it "should redirect to the account page" do
      visit login_path
      user = User.first

      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'testing123'

      submit_form

      expect(page).to have_current_path(logged_in_path)
      expect(page).to have_content user.username
    end
  end

  context "with incorrect details" do
    it "should raise an error" do
      visit login_path

      fill_in 'Email', with: 'blah@blah.com'
      fill_in 'Password', with: 'testing123'

      submit_form

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  describe "already logged in" do
    context "when visiting the login page" do
      it "should take you to your dashboard" do
        log_in

        visit login_path

        expect(page).to have_current_path(logged_in_path)
      end
    end
    
    context "when visiting root url" do
      it "should take you to your dashboard" do
        log_in

        visit 'http://lvh.me'

        expect(Capybara.app_host).to eq "http://testing-account.lvh.me"
      end
    end
  end
end

RSpec.describe "Logging out", type: :feature do
  include AuthHelper

  it "should redirect to the static landing page" do
    log_in
    visit logged_in_path
    
    click_on 'Log out'
    
    expect(page).to have_current_path(root_path)
  end
end