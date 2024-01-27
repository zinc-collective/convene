require_relative "trust_factory"

FactoryBot.define do
  factory :tobias_payout, class: "Tobias::Payout" do
    association(:trust, factory: :tobias_trust)
  end
end
