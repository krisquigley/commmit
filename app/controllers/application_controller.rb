class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  helper_method :nav_header

  protect_from_forgery prepend: true
  before_action :verify_account!

  protected

  def verify_account!
    authenticate_user!

    # If trying to access someone elses account, then redirect them to thier personal account
    if current_user && !helpers.account_belongs_to_current_user?(current_user)
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
