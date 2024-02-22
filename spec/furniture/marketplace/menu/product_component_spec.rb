require "rails_helper"

RSpec.describe Marketplace::Menu::ProductComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(product:, cart:) }
  let(:marketplace) { create(:marketplace) }
  let(:cart) { marketplace.cart_for_shopper(shopper: create(:marketplace_shopper)) }
  let(:product) { create(:marketplace_product, description: product_description, marketplace:) }
  let(:product_description) do
    <<~DESC.chomp
      <p>A delicious fritter made with love</p>

      <p>Make sure to <strong>eat it warm!</strong></p>
    DESC
  end

  it { is_expected.to have_content(vc_test_controller.view_context.humanized_money_with_symbol(product.price)) }
  it { is_expected.to have_no_content("Serves") }

  it "renders the description as rich text" do
    expect(output).to have_css("p", text: "A delicious fritter made with love")
    expect(output).to have_css("strong", text: "eat it warm!")
  end

  context "when the product has servings" do
    let(:product) { create(:marketplace_product, marketplace:, servings: 2) }

    it { is_expected.to have_content("Serves 2") }
  end
end
