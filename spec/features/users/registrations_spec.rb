require 'rails_helper'

RSpec.describe "Signing up for an account", type: :feature do
  include AuthHelper

  context "with the correct details" do
    let!(:user) { build(:user) }

    it "should redirect to the account page" do
      visit signup_path

      fill_in 'Username', with: user.username
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password

      click_on 'Sign up'

      expect(page).to have_content user.username
    end
  end

  context "with the incorrect details" do
    it "should raise errors" do
      visit signup_path

      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Username can't be blank"    
    end

    it "should raise errors" do
      visit signup_path
      fill_in 'Username', with: 'bad username$.'

      click_on 'Sign up'

      expect(page).to have_content "Username must only contain letters a-z, numbers 0-9 and the character -"
    end
  end

  context "when an account already exists with the same name / domain" do
    let!(:user) { build(:user) }
    let!(:account) { create(:account, name: 'Existing Account', subdomain: user.username, owner_user_id: 5) }

    it "should raise an error" do
      visit signup_path

      fill_in 'Username', with: user.username
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password

      expect { click_on 'Sign up' }.to raise_error 'Validation failed: Subdomain has already been taken'
      expect(Account.count).to eq 2 # 'testing-account' is created for all the tests
      expect(User.count).to eq 1
    end
  end
end