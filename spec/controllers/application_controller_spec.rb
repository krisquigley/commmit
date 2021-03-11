# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include AuthHelper

  describe 'accessing an account which does not belong to the user' do
    before do
      find_or_create_test_user
      create(:account, subdomain: 'someaccount')

      # Mimic the router behavior of setting the Devise scope through the env.
      @request.env['devise.mapping'] = Devise.mappings[:user]

      # This account does not exist or belong to the user
      @request.host = 'someaccount.lvh.me'
    end

    it 'should raise an error' do
      log_in

      # assert something
      expect { get :show }.to raise_error 'Not Found'
    end
  end
end
