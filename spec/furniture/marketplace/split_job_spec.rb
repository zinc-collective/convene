require "rails_helper"

RSpec.describe Marketplace::SplitJob, type: :job do
  describe "#perform" do
    let(:marketplace) { create(:marketplace, :with_products, :with_stripe_account, :with_stripe_utility) }
    let(:order) { create(:marketplace_order, :with_products, marketplace:) }

    let(:pending_balance) { double(Stripe::StripeObject, amount: 0, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

    let(:available_balance) { double(Stripe::StripeObject, amount: 0, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

    before do
      # https://docs.stripe.com/api/balance/balance_retrieve?lang=ruby
      allow(Stripe::Balance).to receive(:retrieve).and_return(
        double(Stripe::Balance, pending: [pending_balance], available: [available_balance]) # rubocop:disable RSpec/VerifiedDoubles
      )
    end

    context "when there is a sufficient available balance" do
      before do
        allow(Stripe::Transfer).to receive(:create).and_return(
          double(Stripe::Transfer, id: "trf_1234") # rubocop:disable RSpec/VerifiedDoubles
        )
      end

      let(:available_balance) { double(Stripe::StripeObject, amount: order.vendors_share.cents + 10_00, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

      it "transfers the vendors share into their account" do
        described_class.new.perform(order:)

        expect(Stripe::Transfer).to have_received(:create).with(
          {
            amount: order.vendors_share.cents,
            currency: "usd",
            destination: marketplace.vendor_stripe_account,
            transfer_group: order.id
          },
          {api_key: marketplace.stripe_api_key}
        )
      end

      context "when the order has already been split" do
        let(:order) { create(:marketplace_order, stripe_transfer_id: "st_fake_1234") }

        it "does not create a stripe transfer" do
          described_class.new.perform(order: order)

          expect(Stripe::Transfer).not_to have_received(:create)
        end
      end
    end

    context "when there is not a sufficient available balance" do
      let(:available_balance) { double(Stripe::StripeObject, amount: order.vendors_share.cents - 10_00, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

      let(:pending_balance) { double(Stripe::StripeObject, amount: 20_00, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

      context "when there is a sufficient pending balance" do
        it "logs an event and enqueues itself again" do
          described_class.new.perform(order:)

          expect(order.events.where(description: "Available balance of #{available_balance.amount} insufficient to cover vendors share of #{order.vendors_share.cents}")).to be_present
          expect(order.events.where(description: "Summing Pending and Available balances covers vendors share. Deferring split until #{24.hours.from_now.end_of_day}")).to be_present
          expect(described_class).to have_been_enqueued.with(order: order).at(1.day.from_now.end_of_day)
        end
      end

      context "when there is not a sufficient pending balance" do
        let(:pending_balance) { double(Stripe::StripeObject, amount: 0_00, currency: "usd") } # rubocop:disable RSpec/VerifiedDoubles

        # We don't have a user-notification or alerting system and
        # we're not going to have one anytime "soon", so a useful error seems
        # nice.
        it "logs an event and raises an informative error that an operator may want to escalate to their client" do
          expect do
            described_class.new.perform(order:)
          end.to raise_error(Marketplace::SplitJob::InsufficientBalanceError)

          expect(order.events.where(description: "Available balance of #{available_balance.amount} insufficient to cover vendors share of #{order.vendors_share.cents}")).to be_present
          expect(order.events.where(description: "Pending balance (#{pending_balance.amount}) and Available balance (#{available_balance.amount}) does not covers vendors share #{order.vendors_share.cents}. Add funds to your Stripe Account so your Vendors get paid!")).to be_present
        end
      end
    end
  end
end
