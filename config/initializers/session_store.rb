Rails.application.config.session_store :cookie_store, key: '_commmit_session', domain: 'commmit.app' if Rails.env.production?
Rails.application.config.session_store :cookie_store, key: '_commmit_dev_session', domain: 'commmitapp.com' if Rails.env.development?
Rails.application.config.session_store :cookie_store, key: '_commmit_test_session', domain: 'lvh.me' if Rails.env.test?