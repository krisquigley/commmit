# frozen_string_literal: true

class CustomFailure < Devise::FailureApp
  def route(_scope)
    login_url(subdomain: '')
  end

  def redirect_url
    login_url(subdomain: '')
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
