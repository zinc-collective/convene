require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :request do
  let(:marketplace) { create(:marketplace, stripe_api_key: "fake-stripe-key") }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#create" do
    subject {
      post polymorphic_path([space, room, marketplace, :checkouts])
      response
    }

    let(:stripe_checkout_session) do
      double(Stripe::Checkout::Session, url: "http://stripe.redirect")
    end

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_checkout_session)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({ current_cart: cart.shopper.id })
    end

    context "when a Guest checks out their Cart" do
      let!(:cart) { create(:marketplace_cart, :with_products, marketplace: marketplace) }

      it "creates a Checkout from a Cart" do
        expect { subject }.to change(Marketplace::Checkout, :count).by(1)
        expect(subject).to redirect_to(stripe_checkout_session.url)
      end
    end

    context "when the Cart is empty" do
      let!(:cart) { create(:marketplace_cart, marketplace: marketplace) }

      it "doesn't create a Checkout and shows an error notice" do
        expect { subject }.not_to change(Marketplace::Checkout, :count)
        expect(flash["alert"]).to include("line items can't be blank")
      end
    end
  end
end
