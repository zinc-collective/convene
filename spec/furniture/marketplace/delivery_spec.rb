require "rails_helper"

RSpec.describe Marketplace::Delivery, type: :model do
  subject(:delivery) { described_class.new }

  it { is_expected.to belong_to(:marketplace) }
  it { is_expected.to belong_to(:shopper) }

  describe "#delivery_window" do
    subject(:delivery_window) { delivery.delivery_window }

    it { is_expected.to be_a(Marketplace::Delivery::Window) }
  end

  describe "#window" do
    subject(:window) { delivery.window }

    it { is_expected.to eql(delivery.delivery_window) }
  end
end
