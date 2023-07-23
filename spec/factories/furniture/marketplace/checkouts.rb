FactoryBot.define do
  factory :marketplace_checkout, class: "Marketplace::Checkout" do
    trait :with_cart do
      transient do
        marketplace { nil }
        person { nil }
      end
      after(:build) do |checkout, evaluator|
        shopper = build(:marketplace_shopper, person: evaluator.person.is_a?(Guest) ? nil : evaluator.person)
        checkout.cart = build(:marketplace_cart, marketplace: evaluator.marketplace, shopper: shopper)
      end
    end
  end
end
