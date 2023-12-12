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
    specify { perform_request && assert_select("a", "Add Delivery Area ➕") }
  end

  describe "#new" do
    let(:perform_request) { get polymorphic_path(marketplace.location(:new, child: :delivery_area)) }

    it { is_expected.to be_ok }

    specify do
      perform_request
      assert_select("form input", 5)
      assert_select("#delivery_area_label")
      assert_select("#delivery_area_price")
      assert_select("#delivery_area_order_by")
      assert_select("#delivery_area_delivery_window")
    end
  end

  describe "#create" do
    let(:perform_request) do
      post polymorphic_path(marketplace.location(child: :delivery_areas)), params: {delivery_area: attributes_for(:marketplace_delivery_area)}
    end

    it { is_expected.to redirect_to(marketplace.location(child: :delivery_areas)) }
    specify { expect { perform_request }.to change { marketplace.delivery_areas.reload.count }.by(1) }
  end

  describe "#update" do
    let(:delivery_area) { create(:marketplace_delivery_area, marketplace: marketplace) }
    let(:perform_request) do
      put polymorphic_path(delivery_area.location), params: {
        delivery_area: {
          label: "Dog",
          price: 60.00,
          order_by: "3PM",
          delivery_window: "6pm Same Day"
        }
      }

      delivery_area.reload
    end

    it { is_expected.to redirect_to(marketplace.location(child: :delivery_areas)) }

    specify do
      expect { result }.to change(delivery_area, :label).to("Dog")
        .and(change(delivery_area, :price).to(Money.new(60_00)))
        .and(change(delivery_area, :order_by).to("3PM"))
        .and(change(delivery_area, :delivery_window).to("6pm Same Day"))
    end
  end

  describe "#destroy" do
    let(:as) { :html }
    let(:perform_request) do
      delete polymorphic_path(delivery_area.location), as: as
    end

    let(:delivery_area) { create(:marketplace_delivery_area, marketplace: marketplace) }

    it "discards the Delivery area" do
      expect {
        perform_request
        delivery_area.reload
      }.to change(delivery_area, :kept?).to(false)
        .and(change(delivery_area, :discarded?).to(true))
    end

    context "when the Delivery Area was already discarded" do
      let(:delivery_area) { create(:marketplace_delivery_area, :discarded, marketplace:) }

      context "when the Delivery Area has Carts" do
        it "clears the carts delivery area" do
          cart = create(:marketplace_cart, marketplace:, delivery_area:)
          expect {
            perform_request
            cart.reload
          }.to change(cart, :delivery_area).to(nil)
            .and(change { Marketplace::DeliveryArea.exists?(delivery_area.id) }.to(false))
        end
      end

      context "when the Delivery Area has Orders" do
        it "does not delete the Delivery Area" do
          create(:marketplace_order, marketplace:, delivery_area:)
          expect { perform_request }.not_to change { Marketplace::DeliveryArea.exists?(delivery_area.id) }
        end
      end
    end

    it { is_expected.to redirect_to(marketplace.location(child: :delivery_areas)) }

    context "when a turbo_stream" do
      let(:as) { :turbo_stream }

      it { is_expected.to have_rendered_turbo_stream(:remove, delivery_area) }
    end
  end
end
