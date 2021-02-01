class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
  http_basic_authenticate_with name: ENV.fetch("USERNAME"), password: ENV.fetch("PASSWORD")
end
