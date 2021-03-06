# frozen_string_literal: true

if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: '_commmit_session',
                                                        domain: 'commmit.app'
end
if Rails.env.development?
  Rails.application.config.session_store :cookie_store, key: '_commmit_dev_session',
                                                        domain: 'commmitapp.com'
end
if Rails.env.test?
  Rails.application.config.session_store :cookie_store, key: '_commmit_test_session',
                                                        domain: 'lvh.me'
end
