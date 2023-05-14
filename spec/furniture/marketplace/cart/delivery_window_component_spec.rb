require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryWindowComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(window: window) }

  context "when the window is blank" do
    let(:window) { nil }

    it { is_expected.to have_content("your chosen time") }
  end

  context "when the window is not time-like" do
    let(:window) { "3pm on Sunday" }

    it { is_expected.to have_content("3pm on Sunday") }
  end

  context "when the window is time-like" do
    let(:window_time) { 3.hours.from_now }
    let(:window) { window_time.iso8601 }

    it { is_expected.to have_content(I18n.l(window_time, format: :day_month_date_hour_minute)) }
  end
end
