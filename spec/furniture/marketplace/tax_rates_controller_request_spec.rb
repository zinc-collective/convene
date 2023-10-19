require "rails_helper"

RSpec.describe Marketplace::TaxRatesController, type: :request do
  subject(:result) do
    perform_request
    response
  end

  before { sign_in(space, person) }

  let(:space) { marketplace.space }
  let(:marketplace) { create(:marketplace) }
  let(:person) { create(:membership, space: space).member }

  describe "#new" do
    let(:perform_request) do
      get polymorphic_path(marketplace.location(:new, child: :tax_rate))
    end

    it { is_expected.to be_ok }
    it { is_expected.to render_template(:new) }
  end

  describe "#create" do
    let(:perform_request) do
      post polymorphic_path(marketplace.location(child: :tax_rates)), params: {tax_rate: attributes_for(:marketplace_tax_rate)}
    end

    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }

    specify do
      expect { perform_request }.to change { marketplace.tax_rates.count }.by(1)
    end
  end

  describe "#edit" do
    let(:perform_request) do
      get polymorphic_path(tax_rate.location(:edit))
    end
    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }

    it { is_expected.to render_template(:edit) }

    # @todo For some reason "as" doesn't appear to work with get requests
    # context "when a turbo stream" do
    #   let(:as) { :turbo_steam }

    #   it { is_expected.to have_rendered_turbo_stream(:replace, tax_rate, partial: "form") }
    # end
  end

  describe "#update" do
    let(:perform_request) do
      put(polymorphic_path(tax_rate.location), params: {tax_rate: tax_rate_params}).tap do
        tax_rate.reload
      end
    end

    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace, tax_rate: 15) }
    let(:tax_rate_params) { {label: "Hey", tax_rate: 23} }

    specify { expect { result }.to change(tax_rate, :label).to("Hey") }
    specify { expect { result }.to change(tax_rate, :tax_rate).from(15).to(23) }
    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }

    context "when a turbo stream" do
      let(:perform_request) do
        put(polymorphic_path(tax_rate.location), as: :turbo_stream, params: {tax_rate: tax_rate_params}).tap do
          tax_rate.reload
        end
      end

      it { is_expected.to have_rendered_turbo_stream(:replace, tax_rate, Marketplace::TaxRateComponent.new(tax_rate: tax_rate.reload).render_in(controller.view_context)) }
    end

    context "when the tax rate cannot be updated" do
      let(:tax_rate_params) { {tax_rate: 0} }

      it { is_expected.to render_template(:edit) }

      context "when a a turbo stream" do
        let(:perform_request) do
          put(polymorphic_path(tax_rate.location), as: :turbo_stream, params: {tax_rate: tax_rate_params}).tap do
            tax_rate.reload
          end
        end

        it { is_expected.to have_rendered_turbo_stream(:replace, tax_rate, partial: "form") }
      end
    end
  end

  describe "#destroy" do
    let(:perform_request) do
      delete polymorphic_path(tax_rate.location)
    end

    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }

    specify do
      expect { perform_request }.to(change { Marketplace::TaxRate.exists?(tax_rate.id) }.to(false))
    end

    it { is_expected.to redirect_to(marketplace.location(child: :tax_rates)) }

    context "when a turbo_stream" do
      let(:perform_request) do
        delete polymorphic_path(tax_rate.location), as: :turbo_stream
      end

      it { is_expected.to have_rendered_turbo_stream(:remove, tax_rate) }
    end
  end
end
