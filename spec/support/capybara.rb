require "capybara/rails"
require "selenium/webdriver"

RSpec.configure do |config|
  browser = (ENV["HEADLESS"] == "true") ? :selenium_headless : :selenium
  config.before(type: :system) { driven_by browser, using: :firefox }
end
