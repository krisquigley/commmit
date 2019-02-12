class Github::Issue < Github::Base
  private

  def actions
    [
      "opened",
      "edited",
      "closed",
      "reopened"
    ]
  end

  def validations
    !estimated_effort
  end

  def attributes
    {
      repository_name: repository_name,
      url: parsed_payload[:repository].to_h[:html_url] || parsed_payload.fetch(:html_url),
      issue_id: parsed_payload[:issue].to_h[:id] || parsed_payload.fetch(:id),
      number: Integer((parsed_payload[:issue].to_h[:number] || parsed_payload.fetch(:number))),
      title: parsed_payload[:issue].to_h[:title] || parsed_payload.fetch(:title),
      state: parsed_payload[:issue].to_h[:state] || parsed_payload.fetch(:state),
      estimated_effort: estimated_effort,
      closed_at: parsed_payload[:issue].to_h[:closed_at] || parsed_payload[:closed_at],
      github_user_ids: parsed_payload[:issue].to_h[:assignees] || parsed_payload.fetch(:assignees)
    }
  end

  def repository_name
    parsed_payload[:repository].to_h[:full_name] || parsed_payload.fetch(:html_url)[/github.com\/(.*)\/issues/, 1]
  end

  def estimated_effort
    @estimated_effort ||= Integer((parsed_payload[:issue].to_h[:title] || parsed_payload.fetch(:title))[/\[(.*)\]/, 1]) rescue nil
  end
end