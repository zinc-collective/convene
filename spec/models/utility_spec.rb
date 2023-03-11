# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utility do
  it { is_expected.to validate_presence_of(:utility_slug) }

  describe ".new" do
    it "accepts nested attributes for the utility" do
      uh = described_class.new(utility_slug: :stripe, utility_attributes: {api_token: "asdf"})
      expect(uh.utility.api_token).to eq("asdf")
    end
  end

  describe "#name" do
    it "defaults to the humanized version of the utility slug" do
      utility = described_class.new(utility_slug: :null_utility)
      expect(utility.name).to eq("Null utility")
    end
  end

  describe "#utility" do
    it "exposes its configuration" do
      utility = described_class.new(utility_slug: :null_utility, configuration: {a: :b})
      expect(utility.utility).to be_a(described_class)
      expect(utility.utility.configuration["a"]).to eq("b")
    end
  end

  describe "#configuration" do
    it "starts as an empty hash" do
      expect(build(:utility).configuration).to eq({})
    end

    it "is encrypted" do
      utility = described_class.new(utility_slug: :null_utility, configuration: {a: :b})
      expect(utility.configuration).to eq("a" => "b")
      expect(utility.configuration_ciphertext).not_to be_empty
    end
  end
end
