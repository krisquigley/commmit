class GithubIssueJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_response = Github::Issue.call(payload)

    return if !parsed_response 
    ticket = Ticket.find_or_initialize_by(issue_id: parsed_response.fetch(:issue_id))
    ticket.attributes = parsed_response
    ticket.save!
  end
end
