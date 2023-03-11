require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }
  let(:checkout) { build(:marketplace_checkout, cart: cart) }

  before { create(:stripe_utility, space: space) }

  describe "#create" do
    subject(:completed_request) {
      post polymorphic_path(checkout.location)
      response
    }

    let(:stripe_checkout_session) do
      double(Stripe::Checkout::Session, url: "http://stripe.redirect") # rubocop:disable RSpec/VerifiedDoubles
    end

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_checkout_session)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({guest_shopper_id: cart.shopper.id})
    end

    context "when a Guest checks out their Cart" do
      let(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }

      it "Redirects to Stripe" do
        expect(completed_request).to redirect_to(stripe_checkout_session.url)
      end
    end

    context "when the Cart is empty" do
      let(:cart) { create(:marketplace_cart, marketplace: marketplace) }

      it "shows an error notice" do
        completed_request
        expect(flash[:alert]).to include("line items can't be blank")
      end
    end
  end
end
