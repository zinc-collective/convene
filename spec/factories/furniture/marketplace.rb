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

      orders { Array.new(order_quantity) { association(:marketplace_order) } }
    end

    trait :with_tax_rates do
      transient do
        tax_rate_quantity { 1 }
      end

      tax_rates { Array.new(tax_rate_quantity) { association(:marketplace_tax_rate) } }
    end

    trait :with_notify_emails do
      notify_emails { Array.new((1..3).to_a.sample) { Faker::Internet.email }.join(",") }
    end

    trait :with_delivery_areas do
      transient do
        delivery_area_quantity { 1 }
      end

      delivery_areas { Array.new(delivery_area_quantity) { association(:marketplace_delivery_area, marketplace: instance) } }
    end

    trait :with_products do
      transient do
        product_quantity { 1 }
      end

      products { Array.new(product_quantity) { association(:marketplace_product, marketplace: instance) } }
    end

    trait :with_stripe_account do
      stripe_account { "act_#{SecureRandom.hex(8)}" }
      stripe_webhook_endpoint { "http://act_#{stripe_account}.example.com/" }
      stripe_webhook_endpoint_secret { "SECRET_#{SecureRandom.hex(8)}" }
    end

    trait :full do
      with_tax_rates
      with_delivery_areas
      with_notify_emails
    end
  end

  factory :marketplace_product, class: "Marketplace::Product" do
    name { Faker::TvShows::DrWho.specie }
    price_cents { Random.rand(1_00..999_99) }

    marketplace
  end

  factory :marketplace_cart, class: "Marketplace::Cart" do
    marketplace
    shopper { association(:marketplace_shopper) }

    trait :with_products do
      transient do
        product_quantity { 1 }
      end
      cart_products { Array.new(product_quantity) { association(:marketplace_cart_product, marketplace: marketplace) } }
    end

    trait :with_person do
      transient do
        person { build(:person) }
      end
      shopper { association(:marketplace_shopper, person: person) }
    end
  end

  factory :marketplace_cart_product, class: "Marketplace::CartProduct" do
    transient do
      marketplace { nil }
    end
    quantity { 1 }

    product { association(:marketplace_product, marketplace: marketplace) }
    cart { association(:marketplace_cart, marketplace: marketplace) }
  end

  factory :marketplace_order, class: "Marketplace::Order" do
    marketplace
    shopper { association(:marketplace_shopper) }

    id { SecureRandom.uuid }
    status { :paid }

    trait :with_products do
      transient do
        product_count { 1 }
      end

      ordered_products { Array.new(product_count) { association(:marketplace_ordered_product) } }
    end

    trait :with_taxed_products do
      with_products

      marketplace { association(:marketplace, :with_tax_rates) }

      after(:build) do |order|
        order.ordered_products.each do |ordered_product|
          (0..2).to_a.sample.times do
            ordered_product.product.tax_rates << order.marketplace.tax_rates.sample
          end
        end
      end
    end

    trait :full do
      with_taxed_products

      transient do
        product_count { (1..5).to_a.sample }
      end

      marketplace { association(:marketplace, :full) }

      delivery_notes { Faker::Movies::HitchhikersGuideToTheGalaxy.marvin_quote }
      delivery_area { marketplace.delivery_areas.sample }
      placed_at { 5.minutes.ago }
      delivery_address { Faker::Address.full_address }
      contact_email { Faker::Internet.email }
      contact_phone_number { Faker::PhoneNumber.cell_phone }
    end
  end

  factory :marketplace_ordered_product, class: "Marketplace::OrderedProduct" do
    association(:product, factory: :marketplace_product)
    association(:order, factory: :marketplace_order)
    quantity { 1 }
  end

  factory :marketplace_shopper, class: "Marketplace::Shopper" do
  end

  factory :marketplace_tax_rate, class: "Marketplace::TaxRate" do
    label { "#{Faker::TvShows::RuPaul.queen} Tax" }
    tax_rate { (1..45).to_a.sample }
    marketplace { association(:marketplace) }
  end

  factory :marketplace_delivery_area, class: "Marketplace::DeliveryArea" do
    marketplace

    label { Faker::Address.city }
    price { Faker::Commerce.price }
  end

  factory :marketplace_delivery, class: "Marketplace::Delivery" do
    marketplace
    shopper { association(:marketplace_shopper) }
  end

  factory :marketplace_cart_delivery, class: "Marketplace::Cart::Delivery" do
    marketplace { association(:marketplace, :with_delivery_areas) }
    delivery_address { Faker::Address.full_address }
    contact_phone_number { Faker::PhoneNumber.phone_number }
    contact_email { Faker::Internet.email }
    delivery_notes { Faker::Quote.famous_last_words }
    delivery_area { marketplace.delivery_areas.sample }
    delivery_area_id { delivery_area.id }
  end
end
