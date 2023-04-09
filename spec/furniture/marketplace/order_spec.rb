require "rails_helper"

RSpec.describe Marketplace::Order, type: :model do
  it { is_expected.to have_many(:ordered_products).dependent(:destroy).inverse_of(:order) }

  it { is_expected.to have_many(:products).through(:ordered_products).inverse_of(:orders) }

  it { is_expected.to belong_to(:marketplace).class_name("Marketplace::Marketplace").inverse_of(:orders) }

  it { is_expected.to belong_to(:shopper).inverse_of(:orders) }
  it { is_expected.to belong_to(:delivery_area).inverse_of(:orders).optional }

  describe "#price_total" do
    subject(:price_total) { order.price_total }

    let(:marketplace) { create(:marketplace, delivery_fee_cents: 1200) }
    let(:order) { create(:marketplace_order, marketplace: marketplace) }
    let(:product_a) { create(:marketplace_product, marketplace: order.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: order.marketplace, tax_rate_ids: [sales_tax.id]) }
    let(:sales_tax) { create(:marketplace_tax_rate, marketplace: order.marketplace, tax_rate: 5.0) }

    before do
      order.ordered_products.create!(product: product_a, quantity: 1)
      order.ordered_products.create!(product: product_b, quantity: 2)
    end

    it { is_expected.to eql(product_a.price + product_b.price * 2 + marketplace.delivery_fee + (product_b.price * 2 * 0.05)) }
  end

  describe "#product_total" do
    subject(:product_total) { order.product_total }

    let(:order) { create(:marketplace_order) }

    let(:product_a) { create(:marketplace_product, marketplace: order.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: order.marketplace) }

    before do
      order.ordered_products.create!(product: product_a, quantity: 3)
      order.ordered_products.create!(product: product_b, quantity: 2)
    end

    it { is_expected.to eql(product_a.price * 3 + product_b.price * 2) }
  end

  describe "#taxes_total" do
    subject(:tax_total) { order.tax_total }

    let(:order) { create(:marketplace_order) }
    let(:product_a) { create(:marketplace_product, marketplace: order.marketplace) }
    let(:product_b) { create(:marketplace_product, marketplace: order.marketplace, tax_rate_ids: [sales_tax.id]) }
    let(:sales_tax) { create(:marketplace_tax_rate, marketplace: order.marketplace, tax_rate: 5.0) }

    before do
      order.ordered_products.create!(product: product_a, quantity: 3)
      order.ordered_products.create!(product: product_b, quantity: 1)
    end

    it { is_expected.to eql(product_b.price * 0.05) }
  end
end
