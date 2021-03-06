# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    # GET /resource/confirmation/new
    # def new
    #   super
    # end

    # POST /resource/confirmation
    # def create
    #   super
    # end

    # GET /resource/confirmation?confirmation_token=abcdef
    # def show
    #   super
    # end

    # protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(_resource_name)
      login_url(subdomain: '')
    end

    # The path used after confirmation.
    def after_confirmation_path_for(_resource_name, resource)
      logged_in_url(subdomain: resource.personal_account.subdomain, only_path: false)
    end
  end
end
