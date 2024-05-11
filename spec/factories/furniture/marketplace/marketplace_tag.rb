FactoryBot.define do
  factory :marketplace_tag, class: "Marketplace::Tag" do
    bazaar { association(:marketplace_bazaar) }
    label { Faker::Lorem.word }

    trait :group do
      is_group { true }
    end
  end
end
