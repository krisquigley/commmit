class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  
  protect_from_forgery prepend: true
  before_action :authenticate_user!

  protected

  def authenticate_user!
    super

    if !current_user && !request.host.split(ENV.fetch('APP_DOMAIN')).empty?
      # If trying to access a subdomain and not logged in, redirect to login on root domain 
      redirect_to login_url(subdomain: '', only_path: false)
    elsif current_user && request.host.split(ENV.fetch('APP_DOMAIN')).empty?
      # If trying to access root domain and logged in, take them to their root path
      redirect_to logged_in_url(subdomain: current_user.personal_account.subdomain, only_path: false)
    elsif current_user && !current_user.accounts.map(&:subdomain).include?(request.host.split(ENV.fetch('APP_DOMAIN')).join('').gsub(/\./, ''))
      # If trying to access someone elses account, then redirect them to thier personal account
      redirect_to logged_in_url(subdomain: current_user.personal_account.subdomain, only_path: false)
    end
  end
end
