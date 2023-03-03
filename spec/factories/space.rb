# frozen_string_literal: true

FactoryBot.define do
  factory :space do
    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }

    trait :with_members do
      transient do
        member_count { 4 }
      end

      after(:create) do |space, evaluator|
        create_list(:membership, evaluator.member_count, space: space)
      end
    end
  end
end
