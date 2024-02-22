require "rails_helper"

RSpec.describe Marketplace::CartProductComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:cart) { create(:marketplace_cart) }
  let(:marketplace) { cart.marketplace }
  let(:product) { create(:marketplace_product, :with_photo, description: "Hello There") }
  let(:cart_product) { create(:marketplace_cart_product, cart:, product:, quantity: 5) }

  let(:component) { described_class.new(cart_product: cart_product, current_person: operator) }

  it { is_expected.to have_content(product.name) }
  it { is_expected.to have_content(helpers.humanized_money_with_symbol(product.price)) }
  it { is_expected.to have_button("➕") }
  it { is_expected.to have_button("➖") }

  context "when the quantity is 0" do
    let(:cart_product) { build(:marketplace_cart_product, cart:, product:, quantity: 0) }

    it { is_expected.to have_no_button("➖") }
    it { is_expected.to have_button("Add to Cart") }
  end

  context "when the quantity is 1" do
    let(:cart_product) { build(:marketplace_cart_product, cart:, product:, quantity: 1) }

    it { is_expected.to have_button("➕") }
    it { is_expected.to have_button("🗑️") }
  end
end
