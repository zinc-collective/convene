require "rails_helper"

RSpec.describe Marketplace::Checkout do
  subject(:checkout) { described_class.new(cart: cart) }

  describe "#create_stripe_session" do
    let(:delivery_area) { create(:marketplace_delivery_area) }
    let(:cart) { create(:marketplace_cart, delivery_area: delivery_area, marketplace: delivery_area.marketplace) }

    before do
      allow(Stripe::Checkout::Session).to receive(:create)
      allow(cart.marketplace).to receive(:stripe_api_key).and_return("FAKE_KEY_1234")
    end

    it "creates a line item for the delivery fee" do
      checkout.create_stripe_session(success_url: "", cancel_url: "")
      expect(Stripe::Checkout::Session).to have_received(:create) do |arguments|
        expect(arguments[:line_items]).to include(
          quantity: 1,
          price_data: {currency: "USD", unit_amount: cart.delivery_area.price.cents,
                       product_data: {name: "Delivery"}}
        )
      end
    end
  end
end
