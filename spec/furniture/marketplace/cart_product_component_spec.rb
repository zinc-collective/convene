require "rails_helper"

RSpec.describe Marketplace::CartProductComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:cart) { create(:marketplace_cart) }
  let(:marketplace) { cart.marketplace }
  let(:product) { create(:marketplace_product, :with_description, :with_photo) }
  let(:cart_product) { create(:marketplace_cart_product, cart: cart, product: product) }

  let(:component) { described_class.new(cart_product: cart_product, current_person: operator) }

  it { is_expected.to have_content(product.name) }
  it { is_expected.to have_content(product.description) }
  it { is_expected.to have_content(helpers.humanized_money_with_symbol(product.price)) }
  it { is_expected.to have_link(I18n.t("marketplace.cart_product_component.add")) }
  it { is_expected.to have_link(I18n.t("marketplace.cart_product_component.remove")) }
  it { is_expected.to have_css("img[src*='#{product.photo.filename}']") }

  context "when the product is not yet in the cart" do
    let(:cart_product) { build(:marketplace_cart_product, cart: cart, product: product, quantity: 0) }

    it { is_expected.to have_no_link(I18n.t("marketplace.cart_product_component.remove")) }
  end
end
