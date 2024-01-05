require "rails_helper"

RSpec.describe Marketplace::TaxRateComponent, type: :component do
  let(:component) { described_class.new(tax_rate: tax_rate) }
  let(:tax_rate) { create(:marketplace_tax_rate) }

  describe "#render" do
    subject(:output) { render_inline(component) }

    it { is_expected.to have_content(tax_rate.label) }
    it { is_expected.to have_content(component.helpers.number_to_percentage(tax_rate.tax_rate, precision: 2)) }

    context "when current person is null" do
      it { is_expected.to have_no_css("a") }
    end

    context "when current person is a space member" do
      before { component.current_person = create(:membership, space: tax_rate.space).member }

      it { is_expected.to have_link(href: polymorphic_path(tax_rate.location(:edit))) }
      it { is_expected.to have_css("a[data-method='delete'][data-turbo-stream=true][href='#{polymorphic_path(tax_rate.location)}']") }
    end
  end
end
