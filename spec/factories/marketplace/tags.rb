FactoryBot.define do
  factory :marketplace_tag, class: "Marketplace::Tag" do
    sequence(:label) { |n| "#{Faker::Food.allergen} #{n}" }
    marketplace
  end
end
