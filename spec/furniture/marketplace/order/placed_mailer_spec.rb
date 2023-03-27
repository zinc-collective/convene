require "rails_helper"

RSpec.describe Marketplace::Order::PlacedMailer, type: :mailer do
  let(:marketplace) { build(:marketplace, notify_emails: "vendor@example.com,distributor@example.com") }
  let(:order) { build(:marketplace_order, :with_products, delivery_window: 3.minutes.from_now, placed_at: 1.hour.ago, marketplace: marketplace, contact_email: "shopper@example.com") }

  describe "#notification" do
    subject(:mail) { described_class.notification(order) }

    let(:mail_body) { mail.body.encoded }
    let(:document_root_element) { Nokogiri::HTML::Document.parse(mail_body) }

    it { is_expected.to be_to([order.contact_email]) }
    it { is_expected.to have_subject(t(".notification.subject", marketplace_name: order.marketplace_name, order_id: order.id)) }

    it "renders the EmailReceiptComponent" do
      assert_select("##{Marketplace::Order::EmailReceiptComponent.new(order).dom_id}") do
        assert_select("p", t(".notification.placed_at", placed_at: order.placed_at))
      end
    end
  end
end
