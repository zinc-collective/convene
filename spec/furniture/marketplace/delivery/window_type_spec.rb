require "rails_helper"

RSpec.describe Marketplace::Delivery::WindowType do
  subject(:type) { described_class.new }

  describe "#deserialize" do
    subject(:deserialize) { type.deserialize("words") }

    it { is_expected.to eql(Marketplace::Delivery::Window.new(value: "words")) }
  end
end
