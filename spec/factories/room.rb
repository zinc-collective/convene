FactoryBot.define do
  factory :room do
    space
    name { Faker::Book.genre }
    publicity_level { "listed" }

    trait :internal do
      access_level { :internal }
    end

    trait :public do
      access_level { :public }
    end

    trait :listed do
      publicity_level { :listed }
    end

    trait :unlisted do
      publicity_level { :unlisted }
    end

    trait :with_slug do
      slug { name.parameterize }
    end

    trait :with_furniture do
      transient do
        furniture_count { 1 }
      end

      after(:create) do |room, evaluator|
        create_list(:furniture_placement, evaluator.furniture_count, room: room)
      end
    end
  end
end
