RSpec.configure do |config|
  config.before do
    ActiveStorage::Current.url_options = {host: "https://www.example.com"}
  end
end
