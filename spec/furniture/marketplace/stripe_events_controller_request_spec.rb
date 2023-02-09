require "rails_helper"

RSpec.describe Marketplace::StripeEventsController, type: :request do
  let(:marketplace) { create(:marketplace, :with_stripe_utility, stripe_account: "sa_1234", stripe_webhook_endpoint_secret: "whsec_1234") }
  let(:space) { marketplace.space }
  let(:member) { create(:membership, space: space).member }
  let(:order) { create(:marketplace_order, :with_products) }

  let(:stripe_event) { double(Stripe::Event, type: "checkout.session.completed", data: double(object: double(payment_intent: "pi_1234"))) }

  let(:payment_intent) { double(Stripe::PaymentIntent, transfer_group: order.id) }

  before do
    allow(Stripe::Webhook).to receive(:construct_event).with(anything, "sig_1234", marketplace.stripe_webhook_endpoint_secret).and_return(stripe_event)

    allow(Stripe::PaymentIntent).to receive(:retrieve).with("pi_1234", anything).and_return(payment_intent)
    allow(Stripe::Transfer).to receive(:create)
  end

  describe "#create" do
    subject(:call) do
      sign_in(space, member)

      post polymorphic_path(marketplace.location(child: :stripe_events)), headers: {HTTP_STRIPE_SIGNATURE: "sig_1234"}
      response
    end

    specify { call && expect(Stripe::Transfer).to(have_received(:create).with({amount: order.price_total.cents, currency: "usd", destination: marketplace.stripe_account, transfer_group: order.id}, {api_key: marketplace.stripe_api_key})) }

    context "when stripe sends us an event we can't handle" do
      let(:stripe_event) { double(Stripe::Event, type: "a.weird.event") }

      specify { expect { call }.to raise_error(Marketplace::UnexpectedStripeEventTypeError) }
    end
  end
end
