require "rails_helper"

RSpec.describe Marketplace::CartProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }

  describe "#create" do
    it "Add a Product to the Cart" do
      product = create(:marketplace_product, marketplace: marketplace)
      cart = create(:marketplace_cart, marketplace: marketplace)

      post polymorphic_path(cart.location(child: :cart_products), params: {cart_product: {product_id: product.id}})
      expect(response).to redirect_to([space, room])
    end
  end

  describe "#update" do
    it "Changes a Product in the Cart" do
      product = create(:marketplace_product, marketplace: marketplace)
      cart = create(:marketplace_cart, marketplace: marketplace)
      cart_product = create(:marketplace_cart_product, cart: cart, product: product)

      put polymorphic_path([space, room, marketplace, cart, cart_product]), params: {cart_product: {product_id: product.id, quantity: 5}}
      expect(response).to redirect_to([space, room])
    end
  end

  describe "#destroy" do
    it "Removes a Product in the Cart" do
      product = create(:marketplace_product, marketplace: marketplace)
      cart = create(:marketplace_cart, marketplace: marketplace)
      cart_product = create(:marketplace_cart_product, cart: cart, product: product)

      delete polymorphic_path([space, room, marketplace, cart, cart_product])
      expect(response).to redirect_to([space, room])
    end
  end
end
