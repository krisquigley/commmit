# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'when a user is created' do
    let!(:user) { create(:user) }

    it 'should create a personal account and assign the current user to it' do
      user.reload
      expect(user.accounts.first.name).to eq(user.username)
      expect(user.accounts.first.subdomain).to eq(user.username)
      expect(user.accounts.first.account_type).to eq('personal')
      expect(user.accounts.first.owner_user_id).to eq(user.id)
    end
  end
end
