# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commmits', type: :feature do
  include AuthHelper

  before(:each) do
    log_in
  end

  context 'creating a commmit' do
    describe 'with valid data' do
      it 'should create the commmit' do
        visit new_commmit_path

        fill_in 'Name', with: 'Test'

        submit_form

        expect(page).to have_content 'Commmit succesfully created.'
      end
    end
  end

  describe 'viewing a commmit' do
    let!(:commmit) { create(:commmit) }

    it 'should display correctly' do
      visit commmit_path(commmit)

      expect(page).to have_content commmit.name
    end
  end

  describe 'listing commmits' do
    context "when it's less than three days logs" do
      let!(:commmit) { create(:commmit) }

      it 'should show a progress bar'
    end

    context "when it's more than three days logs" do
      it 'should show a burndown'
    end
  end
end
