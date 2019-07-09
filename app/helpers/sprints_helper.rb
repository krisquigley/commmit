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

  def ticket_status(ticket)
    if !!ticket.closed_at 
      "success"
    elsif !ticket.users.empty?
      "warning"
    else
      "danger"
    end
  end

  def status(sprint)
    if sprint.in_progress?
      'In Progress'
    elsif sprint.goal_achieved? 
      'Completed'
    elsif !sprint.goal_achieved?
      'Sprint Ended'
    end
  end

  def effort_to_date(sprint)
    merged_tickets = SprintTicket.merged_tickets(sprint.id)
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
end