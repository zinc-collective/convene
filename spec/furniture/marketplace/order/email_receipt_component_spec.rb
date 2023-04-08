require "rails_helper"

RSpec.describe Marketplace::Order::EmailReceiptComponent, type: :component do
  subject(:content) { render_inline(component) }

  let(:component) { described_class.new(order) }

  context "when the order has a particular time to be delivered" do
    let(:order) { build(:marketplace_order, delivery_window: 3.hours.from_now) }

    it { is_expected.to have_content(I18n.l(order.delivery_window.value, format: :day_month_date_hour_minute)) }
  end

  context "when the order has some words for when it is delivered" do
    let(:order) { build(:marketplace_order, delivery_window: "3pm on Sunday") }

    it { is_expected.to have_content("3pm on Sunday") }
  end
end
