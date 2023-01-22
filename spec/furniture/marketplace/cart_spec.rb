require "rails_helper"

RSpec.describe Marketplace::Cart, type: :model do
  it { is_expected.to have_many(:cart_products).dependent(:destroy).inverse_of(:cart) }

  it { is_expected.to have_many(:products).through(:cart_products).inverse_of(:carts) }

  it { is_expected.to belong_to(:marketplace).class_name("Marketplace::Marketplace").inverse_of(:carts) }

  it { is_expected.to belong_to(:shopper).inverse_of(:carts) }

  describe "#price_total" do
    subject(:price_total) { cart.price_total }

    let(:cart) { create(:marketplace_cart) }
    let(:product_a) { create(:marketplace_product, marketplace: cart.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: cart.marketplace) }

    before do
      cart.cart_products.create!(product: product_a, quantity: 1)
      cart.cart_products.create!(product: product_b, quantity: 2)
    end

    it { is_expected.to eql(product_a.price + product_b.price + product_b.price) }
  end
end
