FactoryBot.define do
  factory :utility_hookup do
    sequence(:name) { |n| "#{utility_slug.to_s.humanize} #{n}" }
    association(:space)

    utility_slug { "null" }
    trait :stripe do
      utility_slug { "stripe" }
    end

    factory :stripe_utility do
      utility_slug { "stripe" }
    end
  end
end
