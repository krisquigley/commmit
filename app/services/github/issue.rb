class Github::Issue < Github::Base
  private

  def actions
    [
      "assigned",
      "unassigned",
      "opened",
      "edited",
      "closed",
      "reopened",
      "labeled",
      "unlabeled"
    ]
  end

  def validations
    !estimated_effort
  end

  def attributes
    {
      repository_name: repository_name,
      url: parsed_payload[:issue].to_h[:html_url] || parsed_payload.fetch(:html_url),
      issue_id: parsed_payload[:issue].to_h[:id] || parsed_payload.fetch(:id),
      number: Integer((parsed_payload[:issue].to_h[:number] || parsed_payload.fetch(:number))),
      title: parsed_payload[:issue].to_h[:title] || parsed_payload.fetch(:title),
      state: parsed_payload[:issue].to_h[:state] || parsed_payload.fetch(:state),
      estimated_effort: estimated_effort,
      closed_at: parsed_payload[:issue].to_h[:closed_at] || parsed_payload[:closed_at],
      github_user_ids: github_user_ids,
      assigned_at: assigned_at,
      source: Oj.dump(parsed_payload[:issue] || parsed_payload, mode: :compat)
    }
  end

  def github_user_ids
    assignees = parsed_payload[:issue].to_h[:assignees] || parsed_payload.fetch(:assignees)
    assignees.map do |assignee|
      assignee.fetch(:id)
    end
  end

  def assigned_at
    if parsed_payload[:action] == "opened" && github_user_ids
      parsed_payload[:issue].to_h[:created_at] || parsed_payload[:created_at]
    elsif parsed_payload[:action] == "assigned"
      parsed_payload[:issue].to_h[:updated_at] || parsed_payload[:updated_at]
    end
  end

  def repository_name
    parsed_payload[:repository].to_h[:full_name] || parsed_payload.fetch(:html_url)[/github.com\/(.*)\/issues/, 1]
  end

  def estimated_effort
    @estimated_effort ||= Float((parsed_payload[:issue].to_h[:title] || parsed_payload.fetch(:title))[/\[(.*)\]/, 1]) rescue nil
  end
end