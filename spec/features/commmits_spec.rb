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

        expect(page).to have_content 'Commmit succesfully created'
      end
    end

    context 'using the day buttons' do
      it 'should update the the date accordingly'
    end
  end

  describe 'viewing a commmit' do
    let!(:commmit) { create(:commmit) }

    it 'should display correctly' do
      visit commmit_path(commmit)

      expect(page).to have_content commmit.name
    end

    context 'adding stories' do
      it 'should add them to the commmit'
    end

    context 'marking stories as done' do
      it 'should mark them as complete'
    end
  end

  describe 'listing commmits' do
    context 'when it is starting in the future' do
      it 'should be indicated as such'
    end

    context 'when it is in progress' do
      it 'should be indicated as such'
    end

    context 'when it has finished' do
      it 'should be indicated as such'
    end

    context "when it's less than three days long" do
      let!(:commmit) { create(:commmit) }

      it 'should show a progress bar'
    end

    context "when it's more than three days long" do
      it 'should show a burndown'
    end
  end
end
