module AuthHelper
  def sign_up
    create(:user, username: 'test', email: 'test@example.com', password: 'testing', 
                  password_confirmation: 'testing', account_id: 1, confirmed_at: Time.now)
  end

  def log_in
    name = ENV.fetch('USERNAME')
    password = ENV.fetch('PASSWORD')

    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      visit "http://#{name}:#{password}@www.lvh.me:#{ Capybara.current_session.server.port }"
    end
  end
end 