module TeamsHelper
  def goal_status(sprint)
    if sprint.finished_early? 
      content_tag(:span, "Goal Met Early", class: "badge badge-success")
    elsif sprint.complete?
      content_tag(:span, "Goal Met", class: "badge badge-warning")
    elsif !sprint.closed_at?
      content_tag(:span, "In Progress", class: "badge badge-primary")
    else
      content_tag(:span, "Goal Not Met", class: "badge badge-danger")
    end
  end

  def velocity_status(sprint)
    if sprint.sprint_surpassed?
      content_tag(:span, "Overdelivered", class: "badge badge-success")
    elsif sprint.initial_effort_met?
      content_tag(:span, "Initial Effort Met", class: "badge badge-warning")
    else
      content_tag(:span, "Initial Effort Not Met", class: "badge badge-danger")
    end
  end

  def progress_status(sprint)
    if sprint.finished_early? 
      "success"
    elsif sprint.complete?
      "warning"
    elsif !sprint.closed_at?
      "info"
    else
      "danger"
    end
  end

  def velocity(sprints)
    sprints.select(:final_velocity, :end_date).reverse.to_json
  end

  def happiness_values(sprints)
    # TODO: Refactor
    happiness = sprints.map do |sprint|
      if sprint.retrospectives.any?
        sprint.retrospectives.map do |retro|
          { end_date: sprint.end_date, average_happiness: retro.average_happiness}
        end
      else
        { end_date: sprint.end_date, average_happiness: 0 }
      end
    end.flatten.group_by { |sprint| sprint[:end_date] }.sort
    
    
    happiness.map do |end_date, user_happiness|
      total_user_happiness = user_happiness.count > 1 ? determine_user_happiness(user_happiness) : user_happiness.first[:average_happiness]
      { end_date: end_date, average_happiness: (total_user_happiness / user_happiness.count).round(1) }
    end.to_json
  end

  def no_of_members_per_sprint(sprints)
    sprints.reverse.map(&:no_of_members).to_json
  end

  def velocity_per_person_per_day_per_sprint(sprints)
    sprints.reverse.map { |s| s.velocity_per_person_per_day.round(2) }.to_json
  end

  private

  def determine_user_happiness(user_happiness)
    user_happiness.reduce do |sum, u|
      if sum.is_a? Hash
        sum[:average_happiness] + u[:average_happiness]
      else
        sum + u[:average_happiness]
      end
    end
  end
end