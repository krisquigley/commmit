class SprintTicketJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_response = Github::Issue.call(payload)

    return if !parsed_response 
    ticket = SprintTicket.where(issue_id: parsed_response.fetch(:issue_id))
                         .where(closed_at: nil)
                         .where("start_date => :date AND end_date <= :date", { date: Date.today })
    ticket.update_all!(parsed_response.except(:source))
  end
end
