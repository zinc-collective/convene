FactoryBot.define do
  factory :marketplace_tag, class: "Marketplace::Tag" do
    marketplace { association(:marketplace) }
    sequence(:label) { |n| "#{Faker::Food.allergen} #{n}" }
    sequence(:position) { |n| n }

    trait :menu do
      is_menu { true }
    end
  end
end
