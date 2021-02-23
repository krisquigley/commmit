require 'rails_helper'

RSpec.describe "Signing up for an account", type: :feature do
  include AuthHelper

  before(:each) do
    log_in
  end

  context "with the correct details" do
    it "should redirect to the account page" do
      visit new_user_registration_path

      password = Faker::Lorem.characters(number: 10)

      username = Faker::Internet.username(separators: %w(-))

      fill_in 'Username', with: username
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password

      click_on 'Sign up'

      expect(page).to have_content username
    end
  end

  context "with the incorrect details" do
    it "should raise errors" do
      visit new_user_registration_path

      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Username can't be blank"    
    end

    it "should raise errors" do
      visit new_user_registration_path
      fill_in 'Username', with: 'bad username$.'

      click_on 'Sign up'

      expect(page).to have_content "Username must only contain letters a-z, numbers 0-9 or the character -"
    end
  end

  context "when an account already exists with the same name / domain" do
    let!(:username) { Faker::Internet.username(separators: %w(-)) }
    let!(:account) { create(:account, name: 'Existing Account', subdomain: username) }

    it "should raise an error" do
      visit new_user_registration_path

      password = Faker::Lorem.characters(number: 10)

      fill_in 'Username', with: username
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password

      click_on 'Sign up'

      expect(page).to have_content 'Account must exist'
      expect(Account.count).to eq 2 # WWW account is created for all the tests
      expect(User.count).to eq 0
    end
  end
end