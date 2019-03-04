class SprintTicketJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_response = Github::Issue.call(payload)

    return if !parsed_response 
    tickets = SprintTicket.where(issue_id: parsed_response.fetch(:issue_id))
                          .where(closed_at: nil)
                          .joins(:sprint)
                          .where("sprints.end_date >= ?", Date.today)
    
    SprintTicket.transaction do
      tickets.each do |ticket|
        ticket.update!(parsed_response.except(:source))
      end
    end
  end
end
