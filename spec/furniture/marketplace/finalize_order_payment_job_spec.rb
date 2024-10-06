# frozen_string_literal: true

require "rails_helper"

RSpec.describe Marketplace::FinalizeOrderPaymentJob, type: :job do
  describe "#perform" do
    subject(:action) { described_class.perform_now(order.id, "123") }

    let!(:order) { create(:marketplace_order) }
    let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: nil) }

    before do
      allow(Marketplace::SplitJob).to receive(:perform_later)
      allow(Marketplace::Order::ReceivedMailer).to receive(:notification).and_return(mailer_double)
      allow(Marketplace::Order::PlacedMailer).to receive(:notification).and_return(mailer_double)
      allow(mailer_double).to receive(:deliver_later)
    end

    it "create order events" do
      expect { action }.to change { order.events.reload.size }.from(0).to(3)
    end

    it "call jobs" do
      action
      expect(Marketplace::SplitJob).to have_received(:perform_later)
      expect(mailer_double).to have_received(:deliver_later).exactly(2).times
    end
  end
end
