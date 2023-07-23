require "rails_helper"

RSpec.describe Marketplace::Order::ReceivedMailer, type: :mailer do
  let(:order) { build(:marketplace_order, placed_at: 1.hour.ago, marketplace: marketplace) }

  describe "#notification" do
    subject(:notification) { described_class.notification(order) }

    before do
      marketplace.notification_methods.create(contact_location: "another_place@example.com")
    end

    it { is_expected.to be_to(marketplace.notification_methods.map(&:contact_location)) }

    it { is_expected.to have_subject(t(".notification.subject", marketplace_name: order.marketplace_name, order_id: order.id)) }

    specify do
      expect(notification).to render_component(Marketplace::Order::EmailReceiptComponent)
        .initialized_with(order)
        .containing("p", t(".notification.placed_at", placed_at: order.placed_at))
    end
  end
end
