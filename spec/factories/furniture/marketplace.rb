FactoryBot.define do
  factory :marketplace, class: "Marketplace::Marketplace" do
    room
    trait :with_stripe_utility do
      after(:create) do |marketplace|
        create(:stripe_utility, space: marketplace.room.space)
      end
    end

    trait :with_orders do
      transient do
        order_quantity { 1 }
      end

      after(:build) do |marketplace, evaluator|
        evaluator.order_quantity.times do
          build(:marketplace_order, marketplace: marketplace)
        end
      end
    end
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
    id { SecureRandom.uuid }
    status { :paid }
    association(:shopper, factory: :marketplace_shopper)

    trait :with_products do
      transient do
        product_count { 1 }
      end

      after(:build) do |order, evaluator|
        build_list(:marketplace_ordered_product, evaluator.product_count, order: order)
      end
    end
  end

  factory :marketplace_ordered_product, class: "Marketplace::OrderedProduct" do
    association(:product, factory: :marketplace_product)
    association(:order, factory: :marketplace_order)
    quantity { 1 }
  end

  factory :marketplace_shopper, class: "Marketplace::Shopper" do
  end
end
