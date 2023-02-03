FactoryBot.define do
  factory :marketplace, class: "Marketplace::Marketplace" do
    room
  end

  factory :marketplace_product, class: "Marketplace::Product" do
    name { Faker::TvShows::DrWho.specie }
    price_cents { Random.rand(1_00..999_999) }

    marketplace
  end

  factory :marketplace_cart_product, class: "Marketplace::CartProduct" do
    association(:product, factory: :marketplace_product)
    association(:cart, factory: :marketplace_cart)
  end

  factory :marketplace_cart, class: "Marketplace::Cart" do
    marketplace
    association(:shopper, factory: :marketplace_shopper)

    trait :with_products do
      after(:build) do |cart, _evaluator|
        build(:marketplace_cart_product, cart: cart)
      end
    end
  end

  factory :marketplace_order, class: "Marketplace::Order" do
    marketplace
    status { :paid }
    association(:shopper, factory: :marketplace_shopper)

    trait :with_products
    after(:build) do |order, _evaluator|
      build(:marketplace_ordered_product, order: order)
    end
  end

  factory :marketplace_ordered_product, class: "Marketplace::OrderedProduct" do
    association(:product, factory: :marketplace_product)
    association(:order, factory: :marketplace_order)
  end

  factory :marketplace_shopper, class: "Marketplace::Shopper" do
  end
end
