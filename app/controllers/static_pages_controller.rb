class StaticPagesController < ActionController::Base
  layout 'static_pages'
  before_action :user_signed_in?

  def show
  end

  def user_signed_in?
    super

    # If trying to access root domain and logged in, take them to their root path
    if current_user && request.host.split(ENV.fetch('APP_DOMAIN')).empty?
      redirect_to logged_in_url(subdomain: current_user.personal_account.subdomain, only_path: false)
    end
  end
end