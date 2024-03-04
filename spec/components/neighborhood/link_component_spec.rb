# frozen_string_literal: true

require "rails_helper"

RSpec.describe Neighborhood::LinkComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new }

  it { is_expected.to have_link("Convene", href: ENV.fetch("APP_ROOT_URL")) }
  it { is_expected.to have_content("Space to Work, Play, or Simply Be") }

  context "when an Operator has set custom values" do
    before do
      ENV["NEIGHBORHOOD_NAME"] = "Parsley's Persimmons Cooperative"
      ENV["NEIGHBORHOOD_TAGLINE"] = "The Place for Persimmon People"
      ENV["APP_ROOT_URL"] = "https://parsleys-persimmons-coop.example.com"
    end

    it { is_expected.to have_link("Parsley's Persimmons Cooperative", href: "https://parsleys-persimmons-coop.example.com") }
    it { is_expected.to have_content("The Place for Persimmon People") }
  end
end
