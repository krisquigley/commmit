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

  def effort_to_date(sprint)
    merged_tickets = SprintTicket.merged_tickets(sprint.initial_ticket_ids)
    effort = []
    day = sprint.start_date.to_date
    current_effort = sprint.total_estimated_effort
    
    if remaining_effort = calculate_effort_done_before_start_date(merged_tickets, sprint.start_date.to_date)
      current_effort = current_effort - remaining_effort
    end

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

  private

  def calculate_effort_done_before_start_date(merged_tickets, start_date)
    remaining_tickets = merged_tickets.where('closed_at < ?', start_date)
    
    remaining_tickets ? remaining_tickets.map{ |s| s.estimated_effort }.reduce(:+) : nil
  end
end