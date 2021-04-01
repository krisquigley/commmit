# frozen_string_literal: true

def path_for_resource(resource, record = nil)
  Rails.application.routes.url_helpers.public_send("#{resource.downcase}_path", record)
end
