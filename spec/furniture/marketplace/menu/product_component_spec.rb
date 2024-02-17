require "rails_helper"

RSpec.describe Marketplace::Menu::ProductComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(product:, cart:) }
  let(:marketplace) { create(:marketplace) }
  let(:cart) { create(:marketplace_cart, marketplace:) }
  let(:product) { create(:marketplace_product, marketplace:) }

  it { is_expected.to have_content(vc_test_controller.view_context.humanized_money_with_symbol(product.price)) }
  it { is_expected.to have_no_content("Serves") }

  context "when the product has servings" do
    let(:product) { create(:marketplace_product, marketplace:, servings: 2) }

    it { is_expected.to have_content("Serves 2") }
  end
end
