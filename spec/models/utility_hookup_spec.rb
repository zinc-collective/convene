# frozen_string_literal: true

require "rails_helper"

RSpec.describe UtilityHookup do
  it { is_expected.to validate_presence_of(:utility_slug) }

  describe ".new" do
    it "accepts nested attributes for the utility" do
      uh = described_class.new(utility_slug: :stripe, utility_attributes: {api_token: "asdf"})
      expect(uh.utility.api_token).to eq("asdf")
    end
  end

  describe "#name" do
    it "defaults to the humanized version of the hookup slug" do
      utility_hookup = described_class.new(utility_slug: :null_hookup)
      expect(utility_hookup.name).to eq("Null hookup")
    end
  end

  describe "#utility" do
    it "exposes its configuration" do
      utility_hookup = described_class.new(utility_slug: :null_hookup, configuration: {a: :b})
      expect(utility_hookup.utility).to be_a(described_class)
      expect(utility_hookup.utility.configuration["a"]).to eq("b")
    end
  end

  describe "#configuration" do
    it "starts as an empty hash" do
      uh = create(:stripe_utility)
      expect(uh.configuration).to eq({})
    end

    it "is encrypted" do
      utility_hookup = described_class.new(utility_slug: :null_hookup, configuration: {a: :b})
      expect(utility_hookup.configuration).to eq("a" => "b")
      expect(utility_hookup.configuration_ciphertext).not_to be_empty
    end
  end
end
