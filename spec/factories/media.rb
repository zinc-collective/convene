FactoryBot.define do
  factory :media do
    upload { Rack::Test::UploadedFile.new("spec/fixtures/files/cc-kitten.jpg", "image/jpeg") }

    trait :journal do
      upload { Rack::Test::UploadedFile.new("spec/fixtures/files/cc-journal.jpg", "image/jpeg") }
    end
  end
end
