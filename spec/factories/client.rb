FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
  end
end
