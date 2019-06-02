module SprintsHelper
  def active(path)
    request.path.include?(path) ? "active" : ''
  end

  def goal_achieved?(sprint)
    if sprint.complete? 
      sprint.goal_achieved? ? "success" : "warning"
    else
      "primary"
    end
  end
end