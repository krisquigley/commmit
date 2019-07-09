module SprintTicketsHelper  
  def closed_at_formatted(ticket)
    ticket.closed_at&.to_date&.to_formatted_s(:long) || 'Open'
  end
end