# frozen_string_literal: true

module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), autolink: true)
    markdown.render(text).html_safe
  end

  def request_subdomain(request)
    request.subdomains.join('')
  end

  def account_belongs_to_current_user?(current_user)
    current_user.accounts.map(&:subdomain).include?(current_tenant.subdomain)
  end
end
