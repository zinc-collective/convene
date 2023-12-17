require "rails_helper"

RSpec.describe Marketplace::Archivable::IndexLinkComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(marketplace:, resource:, to_archive: to_archive) }
  let(:to_archive) { false }
  let(:marketplace) { create(:marketplace) }

  context "when the resource is products" do
    let(:resource) { :products }

    it { is_expected.to have_link("Active Products", href: polymorphic_path(marketplace.location(child: :products))) }

    context "when to_archive" do
      let(:to_archive) { true }

      it { is_expected.to have_link("Archived Products", href: polymorphic_path(marketplace.location(child: :products), {archive: true})) }
    end
  end

  context "when the resource is delivery_areas" do
    let(:resource) { :delivery_areas }

    it { is_expected.to have_link("Active Delivery Areas", href: polymorphic_path(marketplace.location(child: :delivery_areas))) }

    context "when to_archive" do
      let(:to_archive) { true }

      it { is_expected.to have_link("Archived Delivery Areas", href: polymorphic_path(marketplace.location(child: :delivery_areas), {archive: true})) }
    end
  end
end
