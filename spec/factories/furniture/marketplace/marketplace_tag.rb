FactoryBot.define do
  factory :marketplace_tag, class: "Marketplace::Tag" do
    marketplace { association(:marketplace) }
    sequence(:label) { |n| "#{Faker::Food.allergen} #{n}" }

    trait :group do
      is_group { true }
    end
  end
end
