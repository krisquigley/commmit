class Admin::ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch("USERNAME"), password: ENV.fetch("PASSWORD")
  layout 'admin'
end
