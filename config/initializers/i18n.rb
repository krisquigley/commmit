# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, _locale, key, _options|
    raise "missing translation: #{key}, #{exception}"
  end
end
