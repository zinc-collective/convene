FactoryBot.define do
  factory :media do
    upload { Rack::Test::UploadedFile.new("spec/fixtures/files/cc-kitten.jpg", "image/jpeg") }
  end
end
