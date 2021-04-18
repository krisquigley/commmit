# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'rails', '~> 6.1'
gem 'turbo-rails', '~> 0.5.9'

# Database
gem 'acts_as_tenant', '~> 0.5.0'
gem 'auto_strip_attributes', '~> 2.6'
gem 'discard', '~> 1.2'
gem 'geared_pagination', '~> 1.1'
gem 'pg', '>= 0.18', '< 2.0'

# Servers
gem 'puma', '~> 5.2'
gem 'sidekiq', '~> 6.1', '>= 6.1.3'

# Caching
gem 'dalli', '~> 2.7', '>= 2.7.11'

# Assets
gem 'bootstrap4-kaminari-views', '~> 1.0', '>= 1.0.1'
gem 'kaminari', '~> 1.2', '>= 1.2.1'
gem 'webpacker', '~> 5.2', '>= 5.2.1'

# APIs
gem 'jbuilder', '~> 2.11', '>= 2.11.2'
gem 'octokit', '~> 4.20'
gem 'oj', '~> 3.11', '>= 3.11.2'

# Markdown
gem 'redcarpet', '~> 3.5', '>= 3.5.1'

# Debug
gem 'faker', '~> 2.15', '>= 2.15.1'
gem 'pry', '~> 0.13.1'

# User authentication
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'devise_invitable', '~> 2.0'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.6', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'foreman', '~> 0.87.2'
  gem 'listen', '~> 3.4', '>= 3.4.1'
  gem 'rubocop-performance', '~> 1.9', '>= 1.9.2'
  gem 'rubocop-rails', '~> 2.9', '>= 2.9.1'
  gem 'solargraph', '~> 0.40.4'
  gem 'solargraph-rails', '~> 0.2.0.pre'
  gem 'web-console', '~> 4.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '~> 3.35', '>= 3.35.3'
  gem 'cucumber-rails', '~> 2.3', require: false
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'rspec-sidekiq', '~> 3.1'
  gem 'rubocop-rspec', '~> 2.1'
  gem 'selenium-webdriver', '~> 4.0.0.alpha7'
  gem 'simplecov', require: false
  gem 'webdrivers', '~> 4.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
