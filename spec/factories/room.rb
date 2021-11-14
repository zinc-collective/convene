FactoryBot.define do
  factory :room do
    space
    name { FFaker::Book.genre }
    publicity_level { 'listed' }

    trait :internal do
      access_level { :internal }
    end

    trait :listed do
      publicity_level { 'listed' }
    end

    trait :unlisted do
      publicity_level { 'unlisted' }
    end

    trait :locked do
      access_level { :locked }
      access_code { 'secret' }
    end

    trait :unlocked do
      access_level { :unlocked }
    end

    trait :with_slug do
      slug { name.parameterize }
    end
  end
end
