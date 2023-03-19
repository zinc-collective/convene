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

    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }
    specify { expect { result }.to change { tax_rate.reload.label }.to("Hey") }
    specify { expect { result }.to change { tax_rate.reload.tax_rate }.to(23) }
  end
end
