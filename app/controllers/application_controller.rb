class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  
  protect_from_forgery prepend: true
  before_action :authenticate_user!
  before_action :verify_account_route

  protected

  def verify_account_route
    # If trying to access someone elses account, then redirect them to thier personal account
    if current_user && !current_user.accounts.map(&:subdomain).include?(request.host.split(ENV.fetch('APP_DOMAIN')).join('').gsub(/\./, ''))
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
