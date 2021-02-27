module AuthHelper
  def log_in
    sign_in User.first
  end

  def find_or_create_test_user
    User.find_by(username: 'testing-account') || User.create(username: 'testing-account', password: 'testing123', 
      password_confirmation: 'testing123', 
      email: 'default@example.com',
      confirmed_at: Time.now)
  end
end 