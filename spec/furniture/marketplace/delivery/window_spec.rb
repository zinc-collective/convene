require "rails_helper"

RSpec.describe Marketplace::Delivery::Window do
  subject(:window) { described_class.new(value: value) }

  describe "#value" do
    subject(:deserialize) { window.value }

    context "when the value is blank" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end

    context "when the value is an iso8601 String" do
      let(:value) { DateTime.parse("2023-01-01 3:00pm").iso8601 }

      it { is_expected.to eql(DateTime.parse("2023-01-01 3:00pm")) }
    end

    context "when the value is a plain string" do
      let(:value) { "This Evening" }

      it { is_expected.to eql(value) }
    end
  end
end
