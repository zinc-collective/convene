require "rails_helper"

RSpec.describe Marketplace::Delivery::Window do
  subject(:window) { described_class.new(value: value) }

  describe "#eql?" do
    let(:value) { "A value"}
    it { is_expected.to be_eql(described_class.new(value: value)) }
    it { is_expected.not_to be_eql(described_class.new(value: "Another value")) }
  end

  describe "#strftime" do
    subject(:strftime) { window.strftime("%Y-%m-%d") }

    context "when the value is not a timelike thing" do
      let(:value) { "Tomorrow how about?" }

      it { is_expected.to eql(value) }
    end

    context "when the value is a timelike thing" do
      let(:value) { 1.hour.from_now }

      it { is_expected.to eql(value.strftime("%Y-%m-%d")) }
    end
  end

  describe "#value" do
    subject(:output) { window.value }

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

    context "when the value is a DateTime" do
      let(:value) { DateTime.parse("2023-01-01 3:00PM") }

      it { is_expected.to eql(value) }
    end
  end
end
