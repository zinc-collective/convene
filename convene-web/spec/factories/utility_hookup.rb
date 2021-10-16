FactoryBot.define do
  factory :utility_hookup do
    sequence(:name) { |n| "#{utility_slug.to_s.humanize} #{n}" }
    association(:space)

    utility_slug { 'null' }
    trait :jitsi do
      utility_slug { 'jitsi' }
    end

    trait :plaid do
      utility_slug { 'plaid' }
      configuration do
        {
          'client_id' => 'a-fake-client-id',
          'secret' => 'a-fake-secret',
          'environment' => 'sandbox',
        }
      end
    end
  end
end
