require "rails_helper"

RSpec.describe Marketplace::OrderReceivedMailer do
  let(:order) { create(:marketplace_order, :with_products) }
  let(:marketplace) { order.marketplace }

  describe "#notification" do
    subject(:mail) { described_class.notification(order) }

    before { marketplace.update(notify_emails: "vendor@example.com,distributor@example.com") }

    specify { expect(mail.to).to eql(marketplace.notify_emails.split(',')) }
  end
end
