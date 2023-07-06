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

  it { is_expected.to have_content(t(".missing.products", link: t("marketplace.products.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.products.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :product))) }

  it { is_expected.to have_content(t(".missing.delivery_areas", link: t("marketplace.delivery_areas.new.link_to"))) }
  it { is_expected.to have_link(t("marketplace.delivery_areas.new.link_to"), href: polymorphic_path(marketplace.location(:new, child: :delivery_area))) }
end
