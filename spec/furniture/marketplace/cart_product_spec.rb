require "rails_helper"

RSpec.describe Marketplace::CartProduct, type: :model do
  subject(:cart_product) { build(:marketplace_cart_product) }

  it { is_expected.to belong_to(:cart).inverse_of(:cart_products) }

  it { is_expected.to belong_to(:product).inverse_of(:cart_products) }
  it { is_expected.to validate_uniqueness_of(:product).scoped_to(:cart_id) }

  describe "#quantity" do
    let(:cart) { create(:marketplace_cart, :with_products) }

    it "can't be edited for a checked_out cart" do
      cart.cart_products.first.update!(quantity: 42)
      cart.checked_out!
      expect { cart.cart_products.first.update!(quantity: 17) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
