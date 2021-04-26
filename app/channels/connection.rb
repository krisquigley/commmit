# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_tenant_by_subdomain(:account, :subdomain)
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
    end

    protected

    def find_verified_user
      # this checks whether a user is authenticated with devise
      if verified_user == env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
