require "rails_helper"

RSpec.describe Marketplace::Cart, type: :model do
  it { is_expected.to have_many(:cart_products).dependent(:destroy).inverse_of(:cart) }

  it { is_expected.to have_many(:products).through(:cart_products).inverse_of(:carts) }

  it { is_expected.to belong_to(:marketplace).class_name("Marketplace::Marketplace").inverse_of(:carts) }

  it { is_expected.to belong_to(:shopper).inverse_of(:carts) }

  describe "#price_total" do
    subject(:price_total) { cart.price_total }

    let(:marketplace) { create(:marketplace, delivery_fee_cents: 1200) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:product_a) { create(:marketplace_product, marketplace: cart.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: cart.marketplace, tax_rate_ids: [sales_tax.id]) }
    let(:sales_tax) { create(:marketplace_tax_rate, marketplace: cart.marketplace, tax_rate: 5.0) }

    before do
      cart.cart_products.create!(product: product_a, quantity: 1)
      cart.cart_products.create!(product: product_b, quantity: 2)
    end

    it { is_expected.to eql(product_a.price + product_b.price * 2 + (product_b.price * 2 * 0.05)) }

    context "when the #delivery_address is present" do
      let(:cart) { create(:marketplace_cart, delivery_address: "123", marketplace: marketplace) }

      it { is_expected.to eql(product_a.price + product_b.price * 2 + marketplace.delivery_fee + (product_b.price * 2 * 0.05)) }
    end
  end

  describe "#product_total" do
    subject(:product_total) { cart.product_total }

    let(:cart) { create(:marketplace_cart) }

    let(:product_a) { create(:marketplace_product, marketplace: cart.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: cart.marketplace) }

    before do
      cart.cart_products.create!(product: product_a, quantity: 3)
      cart.cart_products.create!(product: product_b, quantity: 2)
    end

    it { is_expected.to eql(product_a.price * 3 + product_b.price * 2) }
  end

  describe "#taxes_total" do
    subject(:tax_total) { cart.tax_total }

    let(:cart) { create(:marketplace_cart) }
    let(:product_a) { create(:marketplace_product, marketplace: cart.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: cart.marketplace, tax_rate_ids: [sales_tax.id]) }
    let(:sales_tax) { create(:marketplace_tax_rate, marketplace: cart.marketplace, tax_rate: 5.0) }

    before do
      cart.cart_products.create!(product: product_a, quantity: 3)
      cart.cart_products.create!(product: product_b, quantity: 1)
    end

    it { is_expected.to eql(product_b.price * 0.05) }
  end

  describe "#delivery_window" do
    let(:cart) { create(:marketplace_cart) }

    before do
      freeze_time
    end

    context "when the Marketplace has a delivery window" do
      before do
        cart.marketplace.delivery_window = 1.week.from_now
      end

      it "returns the Marketplace delivery window" do
        expect(cart.delivery_window).to eq(1.week.from_now)
      end
    end

    it "is resilient to non-Time stored values" do
      cart.delivery_window = "this is not a time"
      expect(cart.delivery_window).to be_a(Time)
      expect(cart.delivery_window - Time.zone.now).to eq(48.hours)
    end
  end
end
