# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

# Loads environment level configuration from `.env` when it exists.
# Also loads from `.env.development` when `RAILS_ENV=development`
# and from `.env.test` when the `RAILS_ENV=test`
#
gem "dotenv-rails", groups: %i[development test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1"

# Data Transport
#
# Use Puma as the app server
gem "puma", "~> 6.4"

# Browser Layer
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "sprockets-rails"
# Turbo lets us swap chunks of HTML without page reloads: https://github.com/hotwired/turbo-rails
gem "stimulus-rails"
gem "turbo-rails"

# API Layer
#
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11"
gem "rswag-api"
gem "rswag-ui"

# View Layer
#
# Allows us to render .markdown.erb files
gem "redcarpet", "~> 3.6"
# Breadcrumbs!
gem "gretel", "~> 5.0"
# Better UI components
gem "lookbook", ">= 2.0.0.beta.4"
gem "view_component", "~> 3.11"
# QR Code Generation!
gem "rqrcode", "~> 2.2"

# Pagination!
gem "pagy", "~> 7.0"

# Database Layer
#
# Postgres extensions for ActiveRecord
# @see https://github.com/GeorgeKaraszi/ActiveRecordExtended
gem "active_record_extended", "~> 3.2"
# Postgres enums
gem "activerecord-postgres_enum", "~> 2.0"
# Support for models with "slots" or "positions"
gem "ranked-model", "~> 0.4.9"
# Slug-based model lookup
gem "friendly_id", "~> 5.5.1"
# Hashing / Encrypting data at rest
gem "bcrypt", "~> 3.1.20"
gem "lockbox", "1.3.3"
gem "rotp", "~> 6.3"
gem "strong_migrations", "~> 1.8"
# Soft Deletion
gem "discard", "~> 1.2"

# ActiveModel extension to remove extra whitespace from attributes
gem "strip_attributes", "~> 1.13"

# Use postgresql for data persistence
gem "pg", "~> 1.5"

# For image manipulation in Active Storage
gem "image_processing"

# Use S3 for file storage
gem "aws-sdk-s3", "~> 1.146", require: false
# Date/Time and Internationalization
#
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 1.2021", platforms: %i[mingw mswin x64_mingw jruby]

# Performance Optimization
#
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Permissions and policies
gem "pundit", "~> 2.3"
gem "decent_exposure", "~> 3.0"

# Utility support
gem "money-rails"
gem "stripe"
gem "square.rb"

# Workers and Background Jobs
gem "sidekiq"

# Error reporting in production
gem "sentry-rails"
gem "sentry-ruby"

# Demo data
gem "factory_bot_rails"
gem "faker"

# Code coverage
gem "simplecov", require: false, group: :test

group :development, :test do
  gem "pry-byebug", platforms: %i[mri mingw x64_mingw]

  # Our preferred testing library for Ruby and Rails projects
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 6.1.2"
  gem "rswag-specs"
  gem "shoulda-matchers", "~> 6.2"

  gem "capybara"
  gem "selenium-webdriver"

  # Let the robots do the request/response faking.
  gem "webmock"

  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "standard", "~> 1.35"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  # Outputs i18n lookup key debug logs
  gem "i18n-debug"
  gem "listen", "~> 3.9"
  gem "rails-erd"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", "~> 4.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", github: "rails/spring-watcher-listen"
end
