# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    before_action :authenticate, only: %i[new], unless: -> { Rails.env.test? }

    def authenticate
      http_basic_authenticate_or_request_with name: ENV.fetch('USERNAME'),
                                              password: ENV.fetch('PASSWORD')
    end
  end
end
