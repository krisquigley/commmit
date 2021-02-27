require 'rails_helper'

RSpec.describe "Logging in", type: :feature do
  context "with incorrect details" do
    it "should raise an error" do
      visit login_path

      fill_in 'Email', with: 'blah@blah.com'
      fill_in 'Password', with: 'testing123'

      submit_form

      expect(page).to have_content 'Invalid Email or password.'
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