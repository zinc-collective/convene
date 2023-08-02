FactoryBot.define do
  factory :utility do
    sequence(:name) { |n| "#{utility_slug.to_s.humanize} #{n}" }
    space

    utility_slug { "null" }
  end

  factory :stripe_utility do
    utility_slug { "stripe" }
    api_token { ENV.fetch("STRIPE_API_KEY", "not_real") }
  end
end
