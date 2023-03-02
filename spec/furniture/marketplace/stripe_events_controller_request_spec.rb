require "rails_helper"

RSpec.describe Marketplace::StripeEventsController, type: :request do
  let(:marketplace) { create(:marketplace, :with_stripe_utility, stripe_account: "sa_1234", stripe_webhook_endpoint_secret: "whsec_1234") }
  let(:space) { marketplace.space }
  let(:member) { create(:membership, space: space).member }
  let(:order) { create(:marketplace_order, :with_products, status: :pre_checkout) }

  let(:stripe_event) do
    double(Stripe::Event, type: "checkout.session.completed",
      data: double(object: double(payment_intent: "pi_1234",
        customer_details: double(email: "test@example.com"),
        shipping: double(name: "Test",
          address: double(line1: "123 N West", line2: "apt 1", city: "Oakland", state: "CA", postal_code: "94609")))))
  end

  let(:balance_transaction) { double(Stripe::BalanceTransaction, fee: 100) }

  let(:payment_intent) do
    double(Stripe::PaymentIntent, transfer_group: order.id,
      charges: [double(Stripe::Charge, balance_transaction: "btx_2234")])
  end

  before do
    allow(Stripe::Webhook).to receive(:construct_event).with(anything, "sig_1234", marketplace.stripe_webhook_endpoint_secret).and_return(stripe_event)

    allow(Stripe::PaymentIntent).to receive(:retrieve).with("pi_1234", anything).and_return(payment_intent)
    allow(Stripe::Transfer).to receive(:create)
    allow(Stripe::BalanceTransaction).to receive(:retrieve).with("btx_2234", anything).and_return(balance_transaction)
  end

  describe "#create" do
    subject(:call) do
      sign_in(space, member)

      post polymorphic_path(marketplace.location(child: :stripe_events)), headers: {HTTP_STRIPE_SIGNATURE: "sig_1234"}
      response
    end

    specify { call && expect(Stripe::Transfer).to(have_received(:create).with({amount: order.price_total.cents - balance_transaction.fee, currency: "usd", destination: marketplace.stripe_account, transfer_group: order.id}, {api_key: marketplace.stripe_api_key})) }

    specify { expect { call }.to have_enqueued_mail(Marketplace::OrderReceivedMailer, :notification).with(order) }

    specify { expect { call }.to change { order.reload.contact_email }.to("test@example.com") }
    specify { expect { call }.to change { order.reload.delivery_address }.to("Test\n123 N West\napt 1\nOakland, CA 94609") }

    context "when stripe sends us an event we can't handle" do
      let(:stripe_event) { double(Stripe::Event, type: "a.weird.event") }

      specify { expect { call }.to raise_error(Marketplace::UnexpectedStripeEventTypeError) }
    end
  end
end
