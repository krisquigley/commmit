require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu window-size=1280,2000 no-sandbox
                              --enable-features=NetworkService,NetworkServiceInProcess) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    url: ENV['SELENIUM_URL'],
    desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome
Capybara.server_host = 'web'
Capybara.default_max_wait_time = 5
Capybara.configure do |config|
  config.always_include_port = true
end