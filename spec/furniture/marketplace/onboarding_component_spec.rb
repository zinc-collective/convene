require "rails_helper"

RSpec.describe Marketplace::OnboardingComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:marketplace) { create(:marketplace) }
  let(:operator) { build(:person, operator: true) }

  let(:component) { described_class.new(marketplace: marketplace, current_person: operator) }

  delegate :link_to, :t, to: :component

  it { is_expected.to have_content(t(".title")) }
  it { is_expected.to have_content(t(".marketplace_hidden", link: t("marketplace.marketplace.edit.link_to"))) }
  it { is_expected.to have_link(t("marketplace.marketplace.edit.link_to"), href: polymorphic_path(marketplace.location(:edit))) }

  it { is_expected.to have_content(t(".missing.notification_methods", link: t("marketplace.notification_methods.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.notification_methods.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :notification_method))) }

  context "when the Marketplace has a NotificationMethod" do
    let(:marketplace) { create(:marketplace, :with_notification_methods) }

    it { is_expected.to have_no_content(t(".missing.notification_methods", link: t("marketplace.notification_methods.new.link_to"))) }
    it { is_expected.to have_no_link(t("marketplace.notification_methods.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :notification_method))) }
  end

  it { is_expected.to have_content(t(".missing.products", link: t("marketplace.products.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.products.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :product))) }

  context "when the Marketplace has a Product" do
    let(:marketplace) { create(:marketplace, :with_products) }

    it { is_expected.to have_no_content(t(".missing.products", link: t("marketplace.products.new.link_to"))) }
    it { is_expected.to have_no_link(t("marketplace.products.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :product))) }
  end

  it { is_expected.to have_content(t(".missing.delivery_areas", link: t("marketplace.delivery_areas.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.delivery_areas.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :delivery_area))) }

  context "when the Marketplace has a DeliveryArea" do
    let(:marketplace) { create(:marketplace, :with_delivery_areas) }

    it { is_expected.to have_no_content(t(".missing.delivery_areas", link: t("marketplace.delivery_areas.new.link_to"))) }
    it { is_expected.to have_no_link(t("marketplace.delivery_areas.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :delivery_area))) }
  end

  it { is_expected.to have_content(t(".missing.stripe_accounts", link: t("marketplace.stripe_accounts.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.stripe_accounts.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :stripe_account))) }

  context "when the Marketplace has a StripeAccount" do
    let(:marketplace) { create(:marketplace, :with_stripe_account) }

    it { is_expected.to have_no_content(t(".missing.stripe_accounts", link: t("marketplace.stripe_accounts.new.link_to"))) }
    it { is_expected.to have_no_link(t("marketplace.stripe_accounts.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :stripe_account))) }
  end
end
