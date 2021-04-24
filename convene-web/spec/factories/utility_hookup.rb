FactoryBot.define do
  factory :utility_hookup do
    trait :jitsi do
      sequence(:name) { |n| "Jitsi #{n}" }
      utility_slug { 'jitsi' }
      configuration { { meet_domain: "http://meet.example.com" } }
    end
  end
end