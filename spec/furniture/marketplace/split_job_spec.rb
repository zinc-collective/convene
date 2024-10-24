require "rails_helper"

RSpec.describe Marketplace::SplitJob, type: :job do
  describe "#perform" do
    before do
      allow(Stripe::Transfer).to receive(:create).and_return(
        double(Stripe::Transfer, id: "trf_1234") # rubocop:disable RSpec/VerifiedDoubles
      )
    end

    let(:marketplace) { create(:marketplace, :with_products, :with_stripe_account, :with_stripe_utility) }
    let(:order) { create(:marketplace_order, :with_products, marketplace:) }

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
end
