FactoryBot.define do
  factory :utility_hookup do
    sequence(:name) { |n| "#{utility_slug.to_s.humanize} #{n}" }
    utility_slug { 'null' }
    trait :jitsi do
      utility_slug { 'jitsi' }
      configuration { { 'meet_domain' => 'http://meet.example.com' } }
    end
  end
end
