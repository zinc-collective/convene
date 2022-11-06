FactoryBot.define do
  factory :marketplace do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, {furniture_kind: "marketplace", room: room}
    end
  end

  factory :marketplace_product, class: "Marketplace::Product" do
    name { Faker::TvShows::DrWho.specie }
    price_cents { Random.rand(1_00..9999_99) }

    association :space
  end
end
