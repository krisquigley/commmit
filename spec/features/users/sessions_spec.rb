# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  context 'with incorrect details' do
    it 'should raise an error' do
      visit login_path

      fill_in t('users.form.email.label'), with: 'blah@blah.com'
      fill_in t('users.form.password.label'), with: 'testing123'

      submit_form

      expect(page).to have_content t('devise.failure.invalid', authentication_keys: 'Email')
    end
  end
end

RSpec.describe 'Logging out', type: :feature do
  include AuthHelper

  it 'should redirect to the static landing page' do
    log_in
    visit logged_in_path

    click_on t('sessions.logout')

    expect(page).to have_current_path(root_path)
  end
end
