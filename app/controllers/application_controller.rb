# frozen_string_literal: true

class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  helper_method :nav_header

  protect_from_forgery prepend: true
  before_action :verify_account!

  protected

  def verify_account!
    authenticate_user!

    return if user_signed_in? && !helpers.request_subdomain(request).present?

    # If trying to access someone elses account, then redirect them to thier personal account
    if user_signed_in? && !helpers.account_belongs_to_current_user?(current_user)
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
