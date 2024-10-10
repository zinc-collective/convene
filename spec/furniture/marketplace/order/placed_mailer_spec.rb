require "rails_helper"

RSpec.describe Marketplace::Order::PlacedMailer, type: :mailer do
  let(:order) { build(:marketplace_order, placed_at: 1.hour.ago, contact_email: "shopper@example.com") }

  describe "#notification" do
    subject(:notification) { described_class.notification(order) }

    it { is_expected.to be_to([order.contact_email]) }

    it "replies to the marketplace's notification emails" do
      expect(notification.reply_to).to eq(order.marketplace.notification_methods.map(&:contact_location))
    end

    it { is_expected.to have_subject(t(".notification.subject", marketplace_name: order.marketplace_name, order_id: order.id)) }

    specify do
      expect(notification).to render_component(Marketplace::Order::EmailReceiptComponent)
        .initialized_with(order)
        .containing("p", t(".notification.placed_at", placed_at: order.placed_at))
    end
  end
end
