# frozen_string_literal: true

namespace 'tickets' do
  desc 'update sprint tickets'
  task update: :environment do
    tickets = Ticket.all

    tickets.each do |ticket|
      sprint_ticket = SprintTicket.where(issue_id: ticket.issue_id)
      sprint_ticket.update_all(source: ticket.source) if sprint_ticket.any?
      print '#'
    end
    print 'Done'
  end
end
