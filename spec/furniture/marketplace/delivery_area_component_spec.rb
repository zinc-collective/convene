require "rails_helper"

RSpec.describe Marketplace::DeliveryAreaComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:component) { described_class.new(delivery_area: delivery_area, current_person: operator) }
  let(:delivery_area) { create(:marketplace_delivery_area) }

  it { is_expected.to have_content(delivery_area.label) }
  it { is_expected.to have_content(vc_test_controller.view_context.humanized_money_with_symbol(delivery_area.price)) }

  it { is_expected.to have_selector("a[href='#{polymorphic_path(delivery_area.location)}'][data-turbo=true][data-turbo-stream=true][data-turbo-method=delete][data-method=delete][data-confirm='#{I18n.t("destroy.confirm")}']") }
  it { is_expected.to have_selector("a[href='#{polymorphic_path(delivery_area.location(:edit))}'][data-turbo=true][data-turbo-method=get][data-turbo-stream=true]") }

  context "when `#delivery_window` is empty" do
    it { is_expected.to have_content "at your chosen time" }
  end

  context "when `#delivery_window` is a string" do
    let(:delivery_area) { create(:marketplace_delivery_area, delivery_window: "dinnertime same day") }

    it { is_expected.to have_content delivery_area.delivery_window }
  end

  context "when #order_by is blank" do
    it { is_expected.not_to have_content "Place orders by" }
  end

  context "when `#order_by` is set" do
    let(:delivery_area) { create(:marketplace_delivery_area, order_by: "noon") }

    it { is_expected.to have_content delivery_area.order_by }
  end
end
