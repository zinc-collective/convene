FactoryBot.define do
  factory :marketplace, class: "Marketplace::Marketplace" do
    room
  end

  factory :marketplace_product, class: "Marketplace::Product" do
    name { Faker::TvShows::DrWho.specie }
    price_cents { Random.rand(1_00..999_999) }

    marketplace
  end

  factory :marketplace_ordered_product, class: "Marketplace::OrderedProduct" do
    association(:product, factory: :marketplace_product)
    association(:order, factory: :marketplace_order)
  end

  factory :marketplace_order, class: "Marketplace::Order" do
    marketplace
  end
end
