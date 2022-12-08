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
    association(:shopper, factory: :person)
  end
end
