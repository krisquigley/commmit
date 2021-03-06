# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@commmit.app'
  layout 'mailer'
end
