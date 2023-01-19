require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :model do
  it { is_expected.to belong_to(:cart).inverse_of(:checkout) }
  it { is_expected.to belong_to(:shopper).inverse_of(:checkouts) }
  it { is_expected.to have_many(:ordered_products).through(:cart).source(:cart_products).class_name("Marketplace::OrderedProduct") }
end
