# frozen_string_literal: true

class SprintTicketJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_response = Github::Issue.call(payload)

    return unless parsed_response

    tickets = SprintTicket.where(issue_id: parsed_response.fetch(:issue_id))
                          .joins(:sprint)
                          .where('sprints.end_date >= ?', Date.today)

    SprintTicket.transaction do
      tickets.each do |ticket|
        ticket.update!(parsed_response)
      end
    end
  end
end
