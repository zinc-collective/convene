FactoryBot.define do
  factory :utility_hookup do
    sequence(:name) { |n| "#{utility_slug.to_s.humanize} #{n}" }
    association(:space)

    utility_slug { 'null' }
    trait :jitsi do
      utility_slug { 'jitsi' }
    end
  end
end
