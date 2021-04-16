# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    unless Rails.env.test?
      http_basic_authenticate_with name: ENV.fetch('USERNAME'),
                                   password: ENV.fetch('PASSWORD')
    end
  end
end
