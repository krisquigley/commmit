module ApplicationHelper
  def active(path)
    request.path.include?(path) ? "active" : ''
  end
end
