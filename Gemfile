source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'rails', '~> 6.1'

# Database
gem 'pg', '>= 0.18', '< 2.0'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'acts_as_tenant', '~> 0.5.0'

# Servers
gem 'puma', '~> 5.2'
gem 'sidekiq', '~> 6.1', '>= 6.1.3'

# Assets
gem 'kaminari', '~> 1.2', '>= 1.2.1'
gem 'bootstrap4-kaminari-views', '~> 1.0', '>= 1.0.1'
gem 'webpacker', '~> 5.2', '>= 5.2.1'

# APIs
gem 'jbuilder', '~> 2.11', '>= 2.11.2'
gem 'oj', '~> 3.11', '>= 3.11.2'
gem 'octokit', '~> 4.20'

# Markdown
gem 'redcarpet', '~> 3.5', '>= 3.5.1'

# Debug
gem 'pry', '~> 0.13.1'
gem 'faker', '~> 2.15', '>= 2.15.1'

# User authentication
gem 'devise', '~> 4.7', '>= 4.7.3'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.6', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.1'
  gem 'listen', '~> 3.4', '>= 3.4.1'
  gem 'foreman', '~> 0.87.2'
  gem 'solargraph', '~> 0.40.4'
  gem 'solargraph-rails', '~> 0.2.0.pre'
  gem 'rubocop-rails', '~> 2.9', '>= 2.9.1'
  gem 'rubocop-performance', '~> 1.9', '>= 1.9.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rubocop-rspec', '~> 2.1'
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'capybara', '~> 3.35', '>= 3.35.3'
  gem 'rspec-sidekiq', '~> 3.1'
  gem 'selenium-webdriver', '~> 4.0.0.alpha7'
  gem 'webdrivers', '~> 4.5'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
