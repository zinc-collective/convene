FactoryBot.define do
  factory :client do
    name { FFaker::Company.name }
  end
end
