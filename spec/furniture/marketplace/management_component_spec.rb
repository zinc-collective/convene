require "rails_helper"

RSpec.describe Marketplace::ManagementComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:component) { described_class.new(marketplace: marketplace, current_person: operator) }
  let(:marketplace) { create(:marketplace) }

  it { is_expected.to have_link(I18n.t("marketplace.payment_settings.index.link_to"), href: polymorphic_path(marketplace.location(child: :payment_settings))) }
  it { is_expected.to have_link(I18n.t("marketplace.products.index.link_to"), href: polymorphic_path(marketplace.location(child: :products))) }
  it { is_expected.to have_link(I18n.t("marketplace.delivery_areas.index.link_to"), href: polymorphic_path(marketplace.location(child: :delivery_areas))) }
  it { is_expected.to have_link(I18n.t("marketplace.tax_rates.index.link_to"), href: polymorphic_path(marketplace.location(child: :tax_rates))) }
  it { is_expected.to have_link(I18n.t("marketplace.orders.index.link_to"), href: polymorphic_path(marketplace.location(child: :orders))) }
  it { is_expected.to have_link(I18n.t("marketplace.notification_methods.index.link_to"), href: polymorphic_path(marketplace.location(child: :notification_methods))) }
  it { is_expected.to have_link(I18n.t("marketplace.vendor_representatives.index.link_to"), href: polymorphic_path(marketplace.location(child: :vendor_representatives))) }
  it { is_expected.to have_link(I18n.t("marketplace.flyers.show.link_to"), href: polymorphic_path(marketplace.location(child: :flyer))) }
end
