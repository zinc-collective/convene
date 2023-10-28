# frozen_string_literal: true

require "rails_helper"

RSpec.describe Marketplace::StripeOverviewComponent, type: :component do
  # pending "add some examples to (or delete) #{__FILE__}"
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(marketplace: marketplace) }

  context "when the Marketplace has a Stripe Utility" do
    let(:marketplace) { create(:marketplace, :with_stripe_utility) }

    it { is_expected.to have_content marketplace.stripe_utility.name }

    it { is_expected.to have_link "View #{I18n.t("marketplace.stripe_accounts.show.link_to")}" }
  end

  context "when the Marketplace is missing a Stripe Utility" do
    let(:marketplace) { create(:marketplace) }

    it { is_expected.to have_link "Add #{I18n.t("marketplace.stripe_accounts.show.link_to")}" }

    it { is_expected.to have_content "To start accepting payments, add your Stripe Account." }
  end
end
