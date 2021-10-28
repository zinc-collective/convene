# frozen_string_literal: true

FactoryBot.define do
  factory :space do
    client
    name { FFaker::CheesyLingo.title }

    trait :default do
      slug { Neighborhood.config.default_space_slug }
    end

    trait :with_members do
      transient do
        member_count { 4 }
      end

      after(:create) do |space, evaluator|
        create_list(:space_membership, evaluator.member_count, space: space)
      end
    end
  end
end
