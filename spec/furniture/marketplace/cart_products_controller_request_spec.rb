require "rails_helper"

RSpec.describe Marketplace::CartProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }

  describe "#create" do
    it "Increase Product quantitity in the Cart" do
      product = create(:marketplace_product, marketplace: marketplace)
      cart = create(:marketplace_cart, marketplace: marketplace)

      post polymorphic_path([space, room, marketplace, cart, :cart_products]), params: {cart_product: {product_id: product.id}}
      expect(response).to redirect_to([space, room])
    end
  end
end
