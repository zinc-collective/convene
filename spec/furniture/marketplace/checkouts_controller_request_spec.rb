require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let!(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }
  let(:checkout) { build(:marketplace_checkout, cart: cart) }
  before do
    create(:utility_hookup, :stripe, space: space)
  end

  describe "#show" do
    context "when a stripe_session_id is in the params" do
      it "marks the cart as checked out" do
        get polymorphic_path(checkout.location, {stripe_session_id: "12345"})

        expect(cart.reload).to be_paid
        expect(response).to redirect_to(cart.becomes(Marketplace::Order).location)
      end
    end
  end

  describe "#create" do
    subject(:completed_request) {
      post polymorphic_path(checkout.location)
      response
    }

    let(:stripe_checkout_session) do
      double(Stripe::Checkout::Session, url: "http://stripe.redirect")
    end

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_checkout_session)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({guest_shopper_id: cart.shopper.id})
    end

    context "when a Guest checks out their Cart" do
      let!(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }

      it "Redirects to Stripe" do
        expect(completed_request).to redirect_to(stripe_checkout_session.url)
      end
    end

    context "when the Cart is empty" do
      let!(:cart) { create(:marketplace_cart, marketplace: marketplace) }

      it "shows an error notice" do
        completed_request
        expect(flash[:alert]).to include("line items can't be blank")
      end
    end
  end
end
