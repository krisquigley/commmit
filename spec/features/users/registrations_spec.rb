# Registration

  # without the correct details
    # should raise an error
    
  # with a username containing spaces and special characters
    # should strip them out automatically
require 'rails_helper'

RSpec.describe "Registration", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  context "with the correct details" do
    it "should redirect to the account page" do
      visit new_user_registration_path

      password = Faker::Lorem.characters(number: 10)

      fill_in 'Username', with: Faker::Internet.username(separators: %w(-))
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password

      click_on 'Sign up'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
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