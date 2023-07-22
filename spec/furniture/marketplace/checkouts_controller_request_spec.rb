require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  let(:checkout) { build(:marketplace_checkout, cart: cart) }

  before { create(:stripe_utility, space: space) }

  describe "#create" do
    subject(:perform_request) {
      post polymorphic_path(checkout.location)
      response
    }

    let(:stripe_checkout_session) do
      double(Stripe::Checkout::Session, url: "http://stripe.redirect") # rubocop:disable RSpec/VerifiedDoubles
    end

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_checkout_session)
    end

    context "when a Visitor checks out their Cart" do
      let(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:session).and_return({guest_shopper_id: cart.shopper.id})
      end

      it "Redirects to Stripe" do
        expect(perform_request).to redirect_to(stripe_checkout_session.url)
      end
    end

    context "when a Neighbor checks out their Cart" do
      let(:cart) { create(:marketplace_cart, :with_person, :with_products, marketplace: marketplace) }

      it "passes the email to stripe" do
        sign_in(space, cart.shopper.person)
        perform_request
        expect(Stripe::Checkout::Session).to have_received(:create).with(
          hash_including(mode: "payment", customer_email: cart.contact_email),
          {api_key: marketplace.stripe_api_key}
        )
      end
    end

    context "when the Cart is empty" do
      let(:cart) { create(:marketplace_cart, marketplace: marketplace) }

      it "shows an error notice" do
        perform_request
        expect(flash[:alert]).to include("line items can't be blank")
      end
    end
  end
end
