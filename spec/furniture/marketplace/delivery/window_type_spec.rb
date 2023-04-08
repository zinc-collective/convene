require "rails_helper"

RSpec.describe Marketplace::Delivery::WindowType do
  let(:type) { described_class.new }

  describe "#deserialize" do
    subject(:deserialize) { type.deserialize("words") }

    it { is_expected.to eql(Marketplace::Delivery::Window.new(value: "words")) }
  end

  describe "#cast" do
    subject(:cast) { type.cast("words") }

    it { is_expected.to eql(Marketplace::Delivery::Window.new(value: "words")) }
  end

  describe "#serialize" do
    subject(:serialize) { type.serialize(Marketplace::Delivery::Window.new(value: "words")) }

    it { is_expected.to eql("words") }
  end
end
