namespace 'tickets' do
  desc "update sprint tickets"
  task update: :environment do
    tickets = Ticket.all

    tickets.each do |ticket|
      sprint_ticket = SprintTicket.find_by(issue_id: ticket.issue_id)
      sprint_ticket.update!(source: ticket.source) if sprint_ticket
      print '#'
    end
    print 'Done'
  end
end