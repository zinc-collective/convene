FactoryBot.define do
  factory :room do
    space
    name { Faker::Book.genre }

    trait :internal do
      access_level { :internal }
    end

    trait :public do
      access_level { :public }
    end

    trait :with_slug do
      slug { name.parameterize }
    end

    trait :with_description do
      description { Faker::TvShows::TheExpanse.quote }
    end

    trait :with_furniture do
      transient do
        furniture_count { 1 }
      end

      after(:create) do |room, evaluator|
        create_list(:furniture, evaluator.furniture_count, room: room)
      end
    end
  end
end
