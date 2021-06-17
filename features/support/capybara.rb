# frozen_string_literal: true

require 'capybara/rails'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless
                              --disable-gpu
                              window-size=1280,2000
                              --no-sandbox
                              --disable-dev-shm-usage
                              --enable-features=NetworkService,NetworkServiceInProcess] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara::Screenshot.register_driver(:selenium_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 5
