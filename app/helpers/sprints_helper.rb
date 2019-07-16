module SprintsHelper
  def active(path)
    request.path.include?(path) ? "active" : ''
  end

  def ticket_status(ticket)
    if !!ticket.closed_at 
      "success"
    elsif !ticket.users.empty?
      "warning"
    else
      "danger"
    end
  end

  def goal_status(sprint)
    if !sprint.closed_at?
      content_tag(:span, "In Progress", class: "badge badge-primary")
    elsif sprint.finished_early? 
      content_tag(:span, "Finished Early", class: "badge badge-success")
    elsif sprint.complete?
      content_tag(:span, "Finished", class: "badge badge-warning")
    else
      content_tag(:span, "Goal Not Met", class: "badge badge-danger")
    end
  end

  def velocity_status(sprint)
    if sprint.sprint_surpassed?
      content_tag(:span, "Overdelivered", class: "badge badge-success")
    elsif sprint.initial_effort_met?
      content_tag(:span, "Met Initial Effort", class: "badge badge-warning")
    elsif !sprint.closed_at?
      content_tag(:span, "Initial Effort not Met", class: "badge badge-primary")
    else
      content_tag(:span, "Underdelivered", class: "badge badge-danger")
    end
  end

  def effort_to_date(sprint)
    merged_tickets = SprintTicket.merged_tickets(sprint.initial_ticket_ids)
    effort = []
    day = sprint.start_date.to_date
    current_effort = sprint.total_estimated_effort

    while day <= Date.today && day <= sprint.end_date do
      tickets = merged_tickets.find_all do |merged_ticket|
        day == merged_ticket.closed_at.to_date
      end

      current_effort = current_effort - tickets.map{ |s| s.estimated_effort }.reduce(:+) if !tickets.empty?

      effort.push(current_effort)
      day = day + 1.day
    end

    effort.to_json
  end

  def average_velocity_per_person_per_day_half_sprint(current_sprint, recent_velocity_per_person_per_day)
    half_a_sprint = current_sprint.sprint_length_in_days / 2
    count = recent_velocity_per_person_per_day.count
    if count > 0
      total_velocity_per_person_per_day = recent_velocity_per_person_per_day.map(&:velocity_per_person_per_day).reduce(&:+)
      ((total_velocity_per_person_per_day / count) * half_a_sprint).round(2)
    else
      0
    end
  end

  def labels(ticket)
    if ticket.source?
      labels = (JSON.parse(ticket.source)["labels"] || JSON.parse(ticket.source)["issue"]["labels"])
                .map { |l| "<span class=\"badge\" style=\"background-color: ##{l["color"]}\">#{l["name"]}</span>" }
      labels.join(" ").html_safe
    end
  end
end