FactoryBot.define do
  factory :marketplace_checkout, class: "Marketplace::Checkout" do
    trait :with_shopper do
      transient do
        person { nil }
      end

      shopper { build(:marketplace_shopper, person: person) }
    end

    trait :with_cart do
      transient do
        marketplace { nil }
      end
      before(:build) do |checkout, evaluator|
        build(:marketplace_cart, marketplace: marketplace, checkout: checkout, shopper: checkout.shopper)
      end
    end
  end
end
