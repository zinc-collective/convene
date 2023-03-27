require "rails_helper"

RSpec.describe Marketplace::Order::ReceivedMailer, type: :mailer do
  let(:marketplace) { build(:marketplace, notify_emails: "vendor@example.com,distributor@example.com") }
  let(:order) { build(:marketplace_order, placed_at: 1.hour.ago, marketplace: marketplace) }

  describe "#notification" do
    subject(:notification) { described_class.notification(order) }

    it { is_expected.to be_to(marketplace.notify_emails.split(",")) }
    it { is_expected.to have_subject(t(".notification.subject", marketplace_name: order.marketplace_name, order_id: order.id)) }

    specify do
      expect(notification).to render_component(Marketplace::Order::EmailReceiptComponent)
        .initialized_with(order)
        .containing("p", t(".notification.placed_at", placed_at: order.placed_at))
    end
  end
end
