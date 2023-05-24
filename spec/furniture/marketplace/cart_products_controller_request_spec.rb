require "rails_helper"

RSpec.describe Marketplace::CartProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }
  let(:document_root_element) { Nokogiri::HTML::Document.parse(response.body) }
  let(:request_as) { :html }

  describe "#create" do
    subject(:perform_request) do
      post path, as: request_as, params: {cart_product: {product_id: product.id, quantity: 1}}
      response
    end

    let(:product) { create(:marketplace_product, marketplace: marketplace) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:path) { polymorphic_path(cart.location(child: :cart_products)) }

    it "Add a Product to the Cart" do
      perform_request

      expect(response).to redirect_to([space, room])
    end

    context "when a turbo stream" do
      let(:request_as) { :turbo_stream }

      it "Replaces the cart product, cart footer and cart total" do
        perform_request && cart.reload

        assert_select("turbo-stream[action='replace'][target='cart_product_#{product.id}']") do
          assert_select("*[data-cart-product-quantity]", text: "1")
        end

        assert_select("turbo-stream[action='replace'][target='cart-footer-#{cart.id}']")
        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}'] *[data-cart-total]", text: "Total: #{controller.helpers.humanized_money_with_symbol(cart.price_total)}")

        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}']") do
          assert_select("*[data-cart-total]", text: "Total: #{controller.helpers.humanized_money_with_symbol(cart.price_total)}")
          assert_select("*[data-cart-product-total]", text: "Products: #{controller.helpers.humanized_money_with_symbol(cart.product_total)}")
        end
      end
    end
  end

  describe "#update" do
    subject(:perform_request) do
      put path, params: params, as: request_as
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
      expect(response).to redirect_to([space, room])
    end

    context "when a turbo stream" do
      let(:request_as) { :turbo_stream }

      it "Replaces the cart product, cart footer and cart total" do
        perform_request && cart.reload

        assert_select("turbo-stream[action='replace'][target='cart_product_#{product.id}']") do
          assert_select("*[data-cart-product-quantity]", text: "5")
        end

        assert_select("turbo-stream[action='replace'][target='cart-footer-#{cart.id}']")
        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}'] *[data-cart-total]", text: "Total: #{controller.helpers.humanized_money_with_symbol(cart.price_total)}")

        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}']") do
          assert_select("*[data-cart-total]", text: "Total: #{controller.helpers.humanized_money_with_symbol(cart.price_total)}")
          assert_select("*[data-cart-product-total]", text: "Products: #{controller.helpers.humanized_money_with_symbol(cart.product_total)}")
        end
      end
    end
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete path, as: request_as
      response
    end

    let(:path) { polymorphic_path(cart_product.location) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace) }
    let(:product) { create(:marketplace_product, marketplace: marketplace) }
    let(:cart_product) { create(:marketplace_cart_product, cart: cart, product: product) }

    it { is_expected.to redirect_to([space, room]) }
    specify { expect { perform_request }.to change { Marketplace::CartProduct.exists?(cart_product.id) }.to(false) }

    context "when a turbo stream" do
      let(:request_as) { :turbo_stream }

      it "Replaces the cart product, cart footer and cart total" do
        perform_request

        assert_select("turbo-stream[action='replace'][target='cart_product_#{cart_product.product_id}']") do
          assert_select("*[data-cart-product-quantity]", text: "0")
        end

        assert_select("turbo-stream[action='replace'][target='cart-footer-#{cart.id}']")
        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}'] *[data-cart-total]", text: "Total: $0.00")

        assert_select("turbo-stream[action='replace'][target='cart-total-#{cart.id}']") do
          assert_select("*[data-cart-total]", text: "Total: $0.00")
          assert_select("*[data-cart-product-total]", text: "Products: $0.00")
        end
      end
    end
  end
end
