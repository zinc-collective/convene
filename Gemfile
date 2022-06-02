# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

# Loads environment level configuration from `.env` when it exists.
# Also loads from `.env.development` when `RAILS_ENV=development`
# and from `.env.test` when the `RAILS_ENV=test`
#
gem 'dotenv-rails', groups: %i[development test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'

# Data Transport
#
# Use Puma as the app server
gem 'puma', '~> 5.6'

# Browser Layer
gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'sprockets-rails'
# Turbo lets us swap chunks of HTML without page reloads: https://github.com/hotwired/turbo-rails
gem 'stimulus-rails'
gem 'turbo-rails'

# API Layer
#
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
gem 'rswag-api'
gem 'rswag-ui'

# View Layer
#
# Allows us to render .markdown.erb files
gem 'redcarpet', '~> 3.5'
# Breadcrumbs!
gem 'gretel', '~> 4.4'

# Database Layer
#
# Postgres extensions for ActiveRecord
# @see https://github.com/GeorgeKaraszi/ActiveRecordExtended
gem 'active_record_extended', '~> 2.1'
# Support for models with "slots" or "positions"
gem 'ranked-model', '~> 0.4.8'
# Slug-based model lookup
gem 'friendly_id', '~> 5.4.2'
# Hashing / Encrypting data at rest
gem 'bcrypt', '~> 3.1.18'
gem 'lockbox', '0.6.8'
gem 'rotp', '~> 6.2'

# Use postgresql for data persistence
gem 'pg', '~> 1.3'

# Use S3 for file storage
gem 'aws-sdk-s3', '~> 1.114', require: false
# Date/Time and Internationalization
#
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2021', platforms: %i[mingw mswin x64_mingw jruby]

# Performance Optimization
#
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.12', require: false

# Permissions and policies
gem 'pundit', '~> 2.2'

# Utility hookup support
gem 'plaid', '~> 15.6'

# Workers and Background Jobs
gem 'sidekiq'

# Error reporting in production
gem 'sentry-rails'
gem 'sentry-ruby'

# Demo data
gem 'factory_bot_rails'
gem 'ffaker'

# Code coverage
gem 'simplecov', require: false, group: :test

group :development, :test do
  gem 'pry-byebug', platforms: %i[mri mingw x64_mingw]

  # Our preferred testing library for Ruby and Rails projects
  gem 'rails-controller-testing'
  gem 'rspec-rails', github: 'zinc-collective/rspec-rails', branch: 'combo-have_enqueued_mail-fixes'
  gem 'rswag-specs'
  gem 'shoulda-matchers', '~> 5.1'

  # Let the robots do the request/response faking.
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.7'
  gem 'web-console', '~> 4.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', github: 'rails/spring-watcher-listen'
end
