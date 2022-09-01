# frozen_string_literal: true

FactoryBot.define do
  factory :space do
    client
    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }
    slug { name.gsub(' ', '_').downcase.dasherize }

    trait :default do
      slug { Neighborhood.config.default_space_slug }
    end

    trait :with_client_attributes do
      client_attributes { attributes_for(:client) }
    end

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
