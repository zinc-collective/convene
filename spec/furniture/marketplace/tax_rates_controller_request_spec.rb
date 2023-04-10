require "rails_helper"

RSpec.describe Marketplace::TaxRatesController, type: :request do
  subject(:result) do
    perform_request
    test_response
  end

  before { sign_in(space, person) }

  let(:space) { marketplace.space }
  let(:marketplace) { create(:marketplace) }
  let(:person) { create(:membership, space: space).member }

  describe "#new" do
    let(:perform_request) { get polymorphic_path(marketplace.location(:new, child: :tax_rate)) }

    it { is_expected.to be_ok }
  end

  describe "#create" do
    let(:perform_request) do
      post polymorphic_path(marketplace.location(child: :tax_rates)), params: {tax_rate: attributes_for(:marketplace_tax_rate)}
    end

    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }
  end

  describe "#update" do
    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }
    let(:perform_request) do
      put polymorphic_path(tax_rate.location), params: {tax_rate: {label: "Hey", tax_rate: 23}}
    end

    specify { expect { result }.to change { tax_rate.reload.label }.to("Hey") }
    specify { expect { result }.to change { tax_rate.reload.tax_rate }.to(23) }

    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }

    context "when a turbo steram" do
      subject(:perform_request) do
        put polymorphic_path(tax_rate.location), as: :turbo_stream, params: {tax_rate: {label: "Hey", tax_rate: 23}}
        response
      end

      it { is_expected.to have_rendered_turbo_stream(:replace, tax_rate, Marketplace::TaxRateComponent.new(tax_rate: tax_rate.reload).render_in(controller.view_context)) }
    end
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete polymorphic_path(tax_rate.location), as: :turbo_stream
      response
    end

    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }

    it { is_expected.to have_rendered_turbo_stream(:remove, tax_rate) }

    specify do
      expect { perform_request }.to(change { Marketplace::TaxRate.exists?(tax_rate.id) }.to(false))
    end
  end
end
