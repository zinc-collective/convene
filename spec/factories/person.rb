# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    email { "#{name.downcase.tr(" ", "-")}@example.com" }

    trait :operator do
      operator { true }
    end
  end
end
