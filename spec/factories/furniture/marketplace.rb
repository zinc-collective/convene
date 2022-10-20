FactoryBot.define do
  factory :marketplace, class: 'Marketplace::Marketplace' do
    room { build(:room) }
  end

  factory :marketplace_product, class: 'Marketplace::Product' do
    name { Faker::TvShows::DrWho.specie }
    price_cents { Random.rand(1_00..999_999) }

    association :space
  end
end
