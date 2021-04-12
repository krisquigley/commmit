# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Signing up for an account', type: :feature do
  include AuthHelper

  context 'with the correct details' do
    let!(:user) { build(:user) }

    it 'should redirect to the account page' do
      visit signup_path

      fill_in t('users.form.username.label'), with: user.username
      fill_in t('users.form.email.label'), with: user.email
      fill_in t('users.form.password.label'), with: user.password
      fill_in t('users.form.password_confirmation.label'), with: user.password

      submit_form

      expect(page).to have_content t('devise.registrations.signed_up')
      expect(page).to have_current_path('/')
    end
  end

  context 'with the incorrect details' do
    it 'should raise errors' do
      visit signup_path

      submit_form

      expect(page).to have_content "#{t('users.form.email.label')} #{t('errors.messages.blank')}"
      expect(page).to have_content "#{t('users.form.password.label')} #{t('errors.messages.blank')}"
      expect(page).to have_content "#{t('users.form.username.label')} #{t('errors.messages.blank')}"
    end

    it 'should raise errors' do
      visit signup_path
      fill_in t('users.form.username.label'), with: 'bad username$.'

      submit_form

      expect(page).to have_content t('users.validation.username')
    end
  end

  context 'when an account already exists with the same name / domain' do
    let!(:user) { build(:user) }
    let!(:account) do
      create(:account, name: 'Existing Account', subdomain: user.username, owner_user_id: 5)
    end

    it 'should raise an error' do
      visit signup_path

      fill_in t('users.form.username.label'), with: user.username
      fill_in t('users.form.email.label'), with: user.email
      fill_in t('users.form.password.label'), with: user.password
      fill_in t('users.form.password_confirmation.label'), with: user.password

      submit_form

      expect(page).to have_content "Accounts #{t('errors.messages.invalid')}"
      expect(Account.count).to eq 2 # 'testing-account' is created for all the tests
      expect(User.count).to eq 1
    end
  end
end
