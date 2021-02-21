require 'rails_helper'

RSpec.describe "Admin Account", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "Creating a new account" do
    it "should show the new account in the list" do
      visit admin_accounts_path

      click_on 'Add Account'

      fill_in 'Name', with: 'Affinity Digital'

      click_on 'Save'

      expect(page).to have_content 'Affinity Digital'
      expect(page).to have_content 'affinitydigital'
    end
  end

  context "when an account already exists" do
    describe "Creating a new account" do
      it "should show the new account in the list" do
        create(:account, name: 'Affinity Digital', subdomain: 'affinitydigital')

        visit admin_accounts_path
  
        click_on 'Add Account'
  
        fill_in 'Name', with: 'Affinity Digital'
  
        click_on 'Save'
  
        expect(page).to have_content 'Subdomain has already been taken'
      end
    end
  end

  describe "Listing accounts" do
    it "should show the test account in the list" do
      visit admin_accounts_path

      expect(page).to have_content 'www'
    end
  end

  describe "Visiting an account" do
    it "should not matter what case the subdomain is in"
  end
end