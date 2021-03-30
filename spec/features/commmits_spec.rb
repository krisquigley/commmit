# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commmits', type: :feature do
  include AuthHelper

  before(:each) do
    log_in
  end

  context 'creating a commmit' do
    let(:date) { Date.today }

    context 'using the day buttons', js: true do
      it 'should update the the date to tomorrow' do
        visit new_commmit_path

        fill_in t('commmits.form.name.label'), with: 'Test'
        find('label[for=tomorrow]').click

        submit_form

        sleep 0.5

        visit commmits_path

        expect(page).to have_content t('commmits.index.statuses.not_started')
      end

      it 'should keep the the date as today' do
        visit new_commmit_path

        fill_in t('commmits.form.name.label'), with: 'Test'
        find('label[for=tomorrow]').click
        sleep 0.5
        find('label[for=today]').click

        submit_form

        sleep 0.5

        visit commmits_path

        expect(page).to have_content t('commmits.index.statuses.in_progress')
      end
    end
  end

  describe 'viewing a commmit' do
    let!(:commmit) { create(:commmit) }

    describe 'adding stories' do
      it 'should add them to the commmit'

      context 'when they are repeatable' do
        it "shouldn't close the original story"
      end
    end

    describe 'marking stories as done' do
      it 'should mark them as complete'
    end
  end

  describe 'listing commmits' do
    context 'when there are no commmits' do
      it 'should be indicated as such' do
        visit commmits_path

        expect(page).to have_content t('commmits.index.no_commmits_yet')
      end
    end

    context 'when it is starting in the future' do
      let(:date) { Date.tomorrow }
      let!(:commmit) { create(:commmit, start_date: date) }

      it 'should be indicated as such' do
        visit commmits_path

        expect(page).to have_content t('commmits.index.statuses.not_started')
      end
    end

    context 'when it is in progress' do
      let(:date) { Date.today }
      let!(:commmit) { create(:commmit, start_date: date, length_in_days: 3) }

      it 'should be indicated as such' do
        visit commmits_path

        expect(page).to have_content t('commmits.index.statuses.in_progress')
      end
    end

    context 'when it has finished' do
      let(:date) { Date.yesterday }
      let!(:commmit) { create(:commmit, start_date: date) }

      it 'should be indicated as such' do
        visit commmits_path

        expect(page).to have_content t('commmits.index.statuses.finished')
      end
    end

    context "when it's less than three days long" do
      it 'should show a progress bar'
    end

    context "when it's more than three days long" do
      it 'should show a burndown'
    end
  end
end
