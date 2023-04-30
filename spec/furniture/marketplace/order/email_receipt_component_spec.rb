require "rails_helper"

RSpec.describe Marketplace::Order::EmailReceiptComponent, type: :component do
  subject(:content) { render_inline(component) }

  let(:component) { described_class.new(order) }
  let(:marketplace) { build(:marketplace, :full) }
  let(:order) { build(:marketplace_order, :full, marketplace: marketplace) }

  context "when the order has a particular time to be delivered" do
    let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, delivery_window: 3.hours.from_now) }
    let(:order) { build(:marketplace_order, delivery_area: delivery_area) }

    it { is_expected.to have_content(I18n.l(order.delivery_window.value, format: :day_month_date_hour_minute)) }
  end

  context "when the order has some words for when it is delivered" do
    let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, delivery_window: "3pm on Sunday") }
    let(:order) { build(:marketplace_order, delivery_area: delivery_area) }

    it { is_expected.to have_content("3pm on Sunday") }
  end

  it { is_expected.to have_content(/Delivering In:\s+ #{order.delivery_area.label}/) }
end
