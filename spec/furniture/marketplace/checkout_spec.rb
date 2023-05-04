require "rails_helper"

RSpec.describe Marketplace::Checkout do
  describe "#create_stripe_session" do
    it "creates a line item for the delivery fee" do
      allow(Stripe::Checkout::Session).to receive(:create)
      delivery_area = create(:marketplace_delivery_area)
      cart = build(:marketplace_cart, delivery_area: delivery_area, marketplace: delivery_area.marketplace)
      checkout = described_class.new(cart: cart)

      allow(cart.marketplace).to receive(:stripe_api_key).and_return("FAKE_KEY_1234")
      checkout.create_stripe_session(success_url: "", cancel_url: "")

      # @todo there is probably some way to actually use the `hash_including` and `array_including` matchers
      # But I couldnt' figure that out as easily as... uhhh.. reaching deep into the internals of rspec to get the stub
      # proxy.
      arguments = RSpec::Mocks.space.proxy_for(Stripe::Checkout::Session).messages_arg_list[0][0]

      expect(arguments[:line_items]).to include(quantity: 1,
        price_data: {currency: "USD", unit_amount: cart.delivery_area.price.cents,
                     product_data: {name: "Delivery"}})
    end
  end
end
