require "rails_helper"

RSpec.describe Marketplace::Delivery::WindowType do
  let(:type) { described_class.new }

  describe "#deserialize" do
    subject(:deserialize) { type.deserialize("words") }

    it { is_expected.to eql(Marketplace::Delivery::Window.new(value: "words")) }
  end

  describe "#cast" do
    subject(:cast) { type.cast(input) }

    let(:input) { "words" }

    it { is_expected.to eql(Marketplace::Delivery::Window.new(value: input)) }

    context "when casting a iso8601 date" do
      let(:input) { "2023-01-05" }

      it { is_expected.to eql(Marketplace::Delivery::Window.new(value: DateTime.iso8601("2023-01-05"))) }
    end
  end

  describe "#serialize" do
    subject(:serialize) { type.serialize(Marketplace::Delivery::Window.new(value: "words")) }

    it { is_expected.to eql("words") }
  end
end
