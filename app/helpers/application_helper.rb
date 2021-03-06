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

  def days_ago_in_words(start_date)
    days_ago = Date.today - start_date

    case days_ago
    when 0
      return 'Today'
    when 1
      return 'Yesterday'
    else
      return "#{days_ago} days ago"
    end
  end
end
