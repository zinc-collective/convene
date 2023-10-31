require "rails_helper"
# `Stripe` gem doesn't support verified doubles for some reason...
# rubocop:disable RSpec/VerifiedDoubles
RSpec.describe Marketplace::StripeEventsController, type: :request do
  let(:marketplace) { create(:marketplace, :with_stripe_utility, stripe_account: "sa_1234", stripe_webhook_endpoint_secret: "whsec_1234") }
  let(:space) { marketplace.space }
  let(:member) { create(:membership, space: space).member }
  let(:order) { create(:marketplace_order, :with_products, status: :pre_checkout, marketplace: marketplace) }

  let(:stripe_event) do
    double(Stripe::Event, type: "checkout.session.completed",
      data: double(object: double(payment_intent: "pi_1234", customer_details: double(email: "test@example.com"))))
  end

  let(:balance_transaction) { double(Stripe::BalanceTransaction, fee: 100) }

  let(:payment_intent) do
    double(Stripe::PaymentIntent, transfer_group: order.id, latest_charge: "ch_1234")
  end

  let(:charge) {
    double(Stripe::Charge, balance_transaction: "btx_2234")
  }

  let(:square_order) { instance_double(Marketplace::SquareOrder, send_to_seller_dashboard: nil) }

  before do
    allow(Stripe::Webhook).to receive(:construct_event).with(anything, "sig_1234", marketplace.stripe_webhook_endpoint_secret).and_return(stripe_event)

    allow(Stripe::PaymentIntent).to receive(:retrieve).with("pi_1234", anything).and_return(payment_intent)
    allow(Stripe::Transfer).to receive(:create).and_return(double(Stripe::Transfer, id: "st_fake_1234"))
    allow(Stripe::BalanceTransaction).to receive(:retrieve).with("btx_2234", anything).and_return(balance_transaction)
    allow(Stripe::Charge).to receive(:retrieve).with("ch_1234", anything).and_return(charge)
    allow(Marketplace::SquareOrder).to receive(:new).and_return(square_order)
  end

  describe "#create" do
    subject(:call) do
      post polymorphic_path(order.marketplace.location(child: :stripe_events)), headers: {HTTP_STRIPE_SIGNATURE: "sig_1234"}
      order.reload
      response
    end

    it "transfers the money automatically and notifies the buyer and seller" do # rubocop:disable RSpec/ExampleLength
      expect { call }.to(have_enqueued_mail(Marketplace::Order::ReceivedMailer, :notification).with(order)
      .and(have_enqueued_mail(Marketplace::Order::PlacedMailer, :notification).with(order))
      .and(change(order, :placed_at).from(nil)))

      expect(order.events).to exist(description: "Payment Received")
      expect(order.events).to exist(description: "Notifications to Vendor and Distributor Sent")
      expect(order.events).to exist(description: "Notification to Buyer Sent")

      expect(order).to be_paid
      expect(order.payment_processor_fee_cents).to(eq(balance_transaction.fee))

      perform_enqueued_jobs(only: Marketplace::SplitJob)
      order.reload

      expect(order.stripe_transfer_id).to eq("st_fake_1234")
      expect(order.events).to exist(description: "Payment Split Attempted")
      expect(order.events).to exist(description: "Payment Split Completed")
      expect(Stripe::Transfer).to(have_received(:create).with({amount: order.vendors_share.to_i, currency: "usd", destination: marketplace.stripe_account, transfer_group: order.id}, {api_key: marketplace.stripe_api_key}))
    end

    context "when stripe sends us an event we can't handle" do
      let(:stripe_event) { double(Stripe::Event, type: "a.weird.event") }

      specify { expect { call }.to raise_error(Marketplace::UnexpectedStripeEventTypeError) }
    end

    context "when the order is not in the marketplace" do
      let(:payment_intent) do
        double(Stripe::PaymentIntent, latest_charge: "ch_1234",
          transfer_group: create(:marketplace_order, :with_products, status: :pre_checkout).id)
      end

      it "does not transfer anything or send any emails" do
        call

        expect(response).to be_no_content
        assert_no_enqueued_emails
        expect(order.reload.placed_at).to be_nil

        expect(Stripe::Transfer).not_to(have_received(:create))
      end
    end

    context "when Square notifications are not enabled" do
      it "does not attempt to transfer the order to seller's Square dashboard" do
        call
        expect(square_order).not_to(have_received(:send_to_seller_dashboard))
      end
    end

    context "when Square notifications are enabled" do
      let(:marketplace) { create_marketplace_with_square }
      let(:person) { create(:person) }
      let(:shopper) { create(:marketplace_shopper, person: person) }
      let(:order) { create(:marketplace_order, :with_products, status: :pre_checkout, marketplace: marketplace, shopper: shopper) }

      it "attempts to transfer the order to seller's Square dashboard" do
        call
        expect(Marketplace::SquareOrder).to have_received(:new).with(order)
        expect(square_order).to have_received(:send_to_seller_dashboard)
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
