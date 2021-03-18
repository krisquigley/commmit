# frozen_string_literal: true

module AccountConcern
  extend ActiveSupport::Concern

  class_methods do
    def subdomain_format
      { with: /\A[A-Za-z0-9\-]+\z/,
        message: I18n.t('users.validation.username') } # Username follows the same convention
    end
  end
end
