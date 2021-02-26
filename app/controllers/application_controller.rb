class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  
  protect_from_forgery prepend: true
  before_action :authenticate_user!
  before_action :redirect_to_dashboard

  def redirect_to_dashboard
    if request.host.split(ENV.fetch('APP_DOMAIN')).empty? && current_user
      redirect_to dashboard_url(subdomain: current_user.personal_account.subdomain, only_path: false)
    end
  end
end
