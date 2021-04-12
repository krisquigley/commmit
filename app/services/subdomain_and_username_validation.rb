# frozen_string_literal: true

class SubdomainAndUsernameValidation
  def self.call
    new.call
  end

  def call
    /\A[A-Za-z0-9\-]+\z/
  end
end
