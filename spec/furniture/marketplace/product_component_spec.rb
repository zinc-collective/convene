require "rails_helper"

RSpec.describe Marketplace::ProductComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:component) { described_class.new(product: product, current_person: operator) }
  let(:marketplace) { create(:marketplace) }
  let(:product) { create(:marketplace_product, tax_rates: [tax_rate], marketplace: marketplace) }
  let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }

  it { is_expected.to have_content(tax_rate.label) }
  it { is_expected.to have_content(vc_test_controller.view_context.number_to_percentage(tax_rate.tax_rate, precision: 2)) }
  it { is_expected.to have_content(vc_test_controller.view_context.humanized_money_with_symbol(product.price)) }

  it { is_expected.to have_css("a[href='#{polymorphic_path(product.location(:edit))}'][data-turbo=true][data-turbo-method=get]") }
  it { is_expected.to have_no_link(I18n.t("destroy.link_to")) }
  it { is_expected.to have_link(I18n.t("archive.link_to")) }

  context "when the Product is destroyable" do
    let(:product) { create(:marketplace_product, :archived, marketplace:) }

    it { is_expected.to have_css("a[href='#{polymorphic_path(product.location)}'][data-turbo=true][data-turbo-method=delete][data-method=delete][data-confirm='#{I18n.t("destroy.confirm")}']") }
  end
end
