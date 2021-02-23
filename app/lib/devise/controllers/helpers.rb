def after_sign_in_path_for(resource)
  redirect_to url_for(subdomain: user.account.subdomain, only_path: false)
end