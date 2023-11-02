source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Latest rails framework
gem "rails"

# Falcon async web server(Based on ruby fibers)
gem "falcon"

# Asyncrounous programming paradigm(Based on ruby fibers)
gem "async"

# Postgresql database adapter
gem "pg"

# Redis cache adapter
gem "redis"

# Fast json serializer
gem "oj"

# Fast ruby object serializer
gem 'jsonapi-serializer'

# Because there is no frontend, we need to allow api request from everywhere
gem 'rack-cors'

# API Authentication
gem 'devise'
gem 'devise-jwt'

# Authorization
gem 'access-granted'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Background Processing
gem "sidekiq"

group :development, :test do
  # Environment Variables on local
  gem "dotenv-rails"
  # Rails unit and feature testing
  gem 'factory_bot_rails'         # Making test data effectively
  gem 'faker'                     # Creating fake data for testing
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
end

group :development do
  gem "standard", require: false
  gem "rubocop-rails", require: false
end

group :test do
  gem "debug"
  # Helpers
  gem 'shoulda-matchers'                # Common rspec/minitest one liner tests

  # Coverage
  gem 'simplecov', require: false       # Print test coverage

  gem 'rspec-activemodel-mocks'
  gem 'rspec-sidekiq'                   # Sidekiq test helpers
end
