require "capybara/rails"
require "selenium/webdriver"

RSpec.configure do |config|
  config.before(type: :system) { driven_by :selenium, using: :firefox }
end
