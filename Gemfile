source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

# Loads environment level configuration from `.env` when it exists.
# Also loads from `.env.development` when `RAILS_ENV=development`
# and from `.env.test` when the `RAILS_ENV=test`
#
gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'

# Data Transport
#
# Use Puma as the app server
gem 'puma', '~> 5.5'

# Browser Layer
#
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
# Turbo lets us swap chunks of HTML without page reloads: https://github.com/hotwired/turbo-rails
gem 'turbo-rails'

# API Layer
#
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'

# View Layer
#
# Allows us to render .markdown.erb files
gem 'redcarpet', '~> 3.5'
# Breadcrumbs!
gem 'gretel',  '~> 4.3'

# Database Layer
#
# Postgres extensions for ActiveRecord
# @see https://github.com/GeorgeKaraszi/ActiveRecordExtended
gem 'active_record_extended', '~> 2.0'
# Slug-based model lookup
gem 'friendly_id', '~> 5.4.2'
# Hashing / Encrypting data at rest
gem 'bcrypt', '~> 3.1.7'
gem 'lockbox', '0.6.6'
gem 'rotp', '~> 6.2'

# Use postgresql for data persistence
gem 'pg', '~> 1.2'

# Date/Time and Internationalization
#
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2021', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Performance Optimization
#
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.9', require: false

# Permissions and policies
gem 'pundit', '~> 2.1'

# Utility hookup support
gem 'plaid', '~> 14.8'

# Workers and Background Jobs
gem 'sidekiq'

# Error reporting in production
gem 'sentry-ruby'
gem 'sentry-rails'

# Demo data
gem 'factory_bot_rails'
gem 'ffaker'

# Code coverage
gem 'simplecov', require: false, group: :test

group :development, :test do
  gem 'pry-byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Our preferred testing library for Ruby and Rails projects
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'rails-controller-testing'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.1'
  gem 'listen', '~> 3.7'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
