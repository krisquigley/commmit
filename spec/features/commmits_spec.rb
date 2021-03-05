require "rails_helper"

RSpec.describe "Commmits", type: :feature do
  include AuthHelper
  
  before(:each) do
    log_in
  end

  context "creating a commmit" do
    describe "with valid data" do
      it "should create the commmit" do
        visit new_commmit_path

        fill_in 'Name', with: 'Test'

        submit_form

        expect(page).to have_content 'Commmit succesfully created.'
      end
    end
  end
end