require "rails_helper"

RSpec.describe Marketplace::SplitJob, type: :job do
  describe "#perform" do
    before do
      allow(Stripe::Transfer).to receive(:create)
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
