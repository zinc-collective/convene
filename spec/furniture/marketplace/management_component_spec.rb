require "rails_helper"

RSpec.describe Marketplace::ManagementComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:component) { described_class.new(marketplace: marketplace, current_person: operator) }
  let(:marketplace) { create(:marketplace) }

  it { is_expected.to have_css("a[href='#{polymorphic_path(marketplace.location(child: :products))}']", text: I18n.t("marketplace.products.index.link_to")) }

  it { is_expected.to have_css("a[href='#{polymorphic_path(marketplace.location(child: :delivery_areas))}']", text: I18n.t("marketplace.delivery_areas.index.link_to")) }

  it { is_expected.to have_css("a[href='#{polymorphic_path(marketplace.location(child: :tax_rates))}']", text: I18n.t("marketplace.tax_rates.index.link_to")) }

  it { is_expected.to have_css("a[href='#{polymorphic_path(marketplace.location(child: :orders))}']", text: I18n.t("marketplace.orders.index.link_to")) }
end
