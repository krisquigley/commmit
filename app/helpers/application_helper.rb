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

  def active(path)
    request.path == "/#{path}" ? 'active' : ''
  end

  def preload_icons
    ''.html_safe.tap do |content|
      Dir.entries("#{Rails.root}/public/images/icons").map do |file|
        ignored_files = %w[. ..]

        next if ignored_files.include?(file)

        content << content_tag(:link, '', { rel: :preload, href: "/images/icons/#{file}", as: :image })
      end
    end
  end
end
