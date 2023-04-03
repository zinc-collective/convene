require "rails_helper"

RSpec.describe Marketplace::DeliveryAreasController, type: :request do
  subject(:result) do
    perform_request
    test_response
  end

  before { sign_in(space, person) }

  let(:space) { marketplace.space }
  let(:marketplace) { create(:marketplace) }
  let(:person) { create(:membership, space: space).member }

  describe "#index" do
    let(:perform_request) { get polymorphic_path(marketplace.location(child: :delivery_areas)) }

    it { is_expected.to be_ok }
    specify { perform_request && assert_select("a", "Add Delivery Area") }
  end

  describe "#new" do
    let(:perform_request) { get polymorphic_path(marketplace.location(:new, child: :delivery_area)) }

    it { is_expected.to be_ok }
    specify { perform_request && assert_select("form input", 3) && assert_select("#delivery_area_label") && assert_select("#delivery_area_price") }
  end

  describe "#create" do
    let(:perform_request) do
      post polymorphic_path(marketplace.location(child: :delivery_areas)), params: {delivery_area: attributes_for(:marketplace_delivery_area)}
    end

    it { is_expected.to redirect_to(marketplace.location(child: :delivery_areas)) }
    specify { expect { perform_request }.to change { marketplace.delivery_areas.reload.count }.by(1) }
  end
end
