class GithubIssue
  attr_accessor :parsed_payload
  # TODO: Update table to allow for null estimated_effort
  # Remove option to update estimated effort in app
  # Add HTTP basic auth
  # Add webhook for adding new members
  # Add assigned to

  ACTIONS = [
    "opened",
    "edited",
    "closed",
    "reopened"
  ]
  
  def self.call(payload)
    new(payload).call
  end

  def initialize(payload)
    self.parsed_payload = Oj.load(payload, symbol_keys: true)
  end

  def call
    return if !ACTIONS.include?(parsed_payload.fetch(:action)) || !estimated_effort
    attributes
  end

  private

  def attributes
    {
      issue_id: parsed_payload.fetch(:issue).fetch(:id),
      repository_name: parsed_payload.fetch(:repository).fetch(:full_name),
      number: Integer(parsed_payload.fetch(:issue).fetch(:number)),
      title: parsed_payload.fetch(:issue).fetch(:title),
      state: parsed_payload.fetch(:issue).fetch(:state),
      estimated_effort: estimated_effort ? Integer(estimated_effort) : nil,
      closed_at: parsed_payload.fetch(:issue).fetch(:closed_at),
      github_user_ids: parsed_payload.fetch(:issue).fetch(:assignees)
    }
  end

  def estimated_effort
    @estimated_effort ||= parsed_payload.fetch(:issue).fetch(:title)[/\[(.*)\]/, 1] 
  end
end