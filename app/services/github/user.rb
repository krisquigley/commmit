class Github::User < Github::Base
  private

  def actions
    [
      "added",
      "edited"
    ]
  end

  def attributes
    {
      username: parsed_payload[:member].to_h[:login] || parsed_payload.fetch(:login),
      github_user_id: parsed_payload[:member].to_h[:id] || parsed_payload.fetch(:id),
      source: Oj.dump(parsed_payload[:member] || parsed_payload, mode: :compat)
    }
  end
end