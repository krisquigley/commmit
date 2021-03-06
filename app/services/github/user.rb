# frozen_string_literal: true

module Github
  class User < Github::Base
    private

    def actions
      %w[
        added
        edited
      ]
    end

    def attributes
      {
        github_user_id: parsed_payload[:member].to_h[:id] || parsed_payload.fetch(:id),
        source: Oj.dump(parsed_payload[:member] || parsed_payload, mode: :compat)
      }
    end
  end
end
