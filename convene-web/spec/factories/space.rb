FactoryBot.define do
  factory :space do
    client
    name { FFaker::CheesyLingo.title }
    trait :with_members do
      transient do
        member_count { 4 }
      end

      after(:create) do |space, evaluator|
        create_list(:space_membership, evaluator.member_count, space: space)
      end
    end
  end
end
