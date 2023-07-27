require "capybara/rails"
require "selenium/webdriver"

browser = (ENV["HEADLESS"] == "true") ? :selenium_headless : :selenium
RSpec.configure do |config|
  config.before(type: :system) { driven_by browser, using: :firefox }
end

Capybara.configure do |config|
  config.default_driver = browser
end
