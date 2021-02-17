class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  http_basic_authenticate_with name: ENV.fetch("USERNAME"), password: ENV.fetch("PASSWORD")
  protect_from_forgery prepend: true
  before_action :authenticate_user!
end
