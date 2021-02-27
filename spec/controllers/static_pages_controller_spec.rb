# It 

# It should show the dashboard if logged in on their domain

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  include AuthHelper

  describe "accessing the landing page when not logged in" do
    before do
      # Mimic the router behavior of setting the Devise scope through the env.
      @request.env['devise.mapping'] = Devise.mappings[:user]

      # This account does not exist or belong to the user
      @request.host = 'lvh.me'
    end

    it "should load" do
      get :show

      # assert something
      expect(response.status).to eq(200)
    end
  end

  describe "accessing the landing page when logged in" do
    before do
      # Mimic the router behavior of setting the Devise scope through the env.
      @request.env['devise.mapping'] = Devise.mappings[:user]

      # This account does not exist or belong to the user
      @request.host = 'lvh.me'
    end

    it "should load" do
      log_in

      get :show

      # assert something
      expect(response).to redirect_to 'http://testing-account.lvh.me/'
    end
  end
end