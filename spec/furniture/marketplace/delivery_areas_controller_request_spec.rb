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

  describe "#new" do
    let(:perform_request) { get polymorphic_path(marketplace.location(:new, child: :delivery_area)) }

    it { is_expected.to be_ok }
  end

  describe "#create" do
    let(:perform_request) do
      post polymorphic_path(marketplace.location(child: :delivery_areas)), params: {delivery_area: attributes_for(:marketplace_delivery_area)}
    end

    it { is_expected.to redirect_to(marketplace.location(child: :delivery_areas)) }
  end
end
