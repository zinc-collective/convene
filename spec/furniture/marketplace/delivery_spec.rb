require "rails_helper"

RSpec.describe Marketplace::Delivery, type: :model do
  it { is_expected.to belong_to(:marketplace) }
  it { is_expected.to belong_to(:shopper) }

  describe "#delivery_window" do
    subject(:delivery_window) { described_class.new.delivery_window }

    it { is_expected.to be_a(Marketplace::Delivery::Window) }
  end
end
