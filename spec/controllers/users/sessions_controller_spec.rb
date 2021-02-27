require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe "accessing a subdomain" do
    context "when not logged in" do
      before do
        # Mimic the router behavior of setting the Devise scope through the env.
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @request.host = 'someaccount.lvh.me'
      end
  
      it "should redirect to the login page of root" do
        # Use the sign_in helper to sign in a fixture `User` record.
        get :new
      
        # assert something
        expect(response).to redirect_to 'http://lvh.me/login'
      end
    end
  end

  describe "logging out" do
    before do
      log_in
      # Mimic the router behavior of setting the Devise scope through the env.
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.host = 'testing-account.lvh.me'
    end

    it "should redirect to the login page of root" do
      # Use the sign_in helper to sign in a fixture `User` record.
      get :destroy
    
      # assert something
      expect(response).to redirect_to 'http://lvh.me/'
    end
  end
end
