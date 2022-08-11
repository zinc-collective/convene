FactoryBot.define do
  factory :invitation do
    space
    name { Faker::Name.name }
    email { "#{name.downcase.gsub(' ', '-')}@example.com" }
    invitor factory: :person

    trait :ignored do
      status { "ignored" }
    end
  end
end
