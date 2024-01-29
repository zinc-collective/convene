require "rails_helper"

RSpec.describe Marketplace::CartProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }
  let(:document_root_element) { Nokogiri::HTML::Document.parse(response.body) }

  describe "#create" do
    subject(:perform_request) do
      post path, params: {cart_product: {product_id: product.id, quantity: 1}}
      response
    end

    let(:product) { create(:marketplace_product, marketplace: marketplace) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:path) { polymorphic_path(cart.location(child: :cart_products)) }

    it "Add a Product to the Cart" do
      perform_request

      expect(response).to redirect_to(marketplace.location)
    end
  end

  describe "#update" do
    subject(:perform_request) do
      put path, params: params
    end

    let(:product) { create(:marketplace_product, marketplace: marketplace) }
    let(:path) { polymorphic_path(cart_product.location) }
    let(:params) { {cart_product: {product_id: product.id, quantity: 5}} }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:cart_product) { create(:marketplace_cart_product, cart: cart, product: product) }

    it "Changes the cart product" do
      perform_request
      cart_product.reload
      expect(cart_product.quantity).to eq(5)
      expect(response).to redirect_to(marketplace.location)
    end
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete path
      response
    end

    let(:path) { polymorphic_path(cart_product.location) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:product) { create(:marketplace_product, marketplace: marketplace) }
    let(:cart_product) { create(:marketplace_cart_product, cart: cart, product: product) }

    it { is_expected.to redirect_to(marketplace.location) }
    specify { expect { perform_request }.to change { Marketplace::CartProduct.exists?(cart_product.id) }.to(false) }
  end
end
