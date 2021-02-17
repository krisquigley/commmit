class Admin::ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!
  
  http_basic_authenticate_with name: ENV.fetch("USERNAME"), password: ENV.fetch("PASSWORD")
  layout 'admin'
end
