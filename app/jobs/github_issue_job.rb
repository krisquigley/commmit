class GithubIssueJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_response = GithubIssue.call(payload)

    return if !parsed_response 
    ticket = Ticket.find_or_initialize_by(issue_id: parsed_response.fetch(:issue_id))
    ticket.attributes = parsed_response
    ticket.save!
    
    users = User.where(github_user_id: parsed_response.fetch(:github_user_ids))
    User.transaction do
      users.each do |user|
        user.tickets << ticket
        user.save
      end
    end
  end
end
