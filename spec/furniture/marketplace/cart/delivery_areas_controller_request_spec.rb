require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryAreasController, type: :request do
  subject(:result) do
    perform_request
    response
  end

  before { sign_in(space, person) }

  let(:space) { marketplace.space }
  let(:marketplace) { create(:marketplace, :with_delivery_areas) }
  let(:person) { create(:membership, space: space).member }
  let(:shopper) { create(:marketplace_shopper, person: person) }
  let(:cart) { create(:marketplace_cart, shopper: shopper, marketplace: marketplace) }

  describe "#show" do
    let(:perform_request) do
      get polymorphic_path(cart.location(child: :delivery_area))
      response
    end

    it { is_expected.to be_ok }
  end

  describe "#edit" do
    let(:perform_request) do
      get polymorphic_path(cart.location(:edit, child: :delivery_area))
      response
    end

    it { is_expected.to be_ok }

    specify do
      perform_request
      assert_select("select[name='cart[delivery_area_id]']")
    end
  end

  describe "#update" do
    let(:perform_request) do
      put polymorphic_path(cart.location(child: :delivery_area), params: {cart: {delivery_area_id: marketplace.delivery_areas.first.id}})
      cart.reload
      response
    end

    it { is_expected.to redirect_to(marketplace.location) }

    specify do
      expect { result }.to change(cart, :delivery_area_id).to(marketplace.delivery_areas.first.id)
    end
  end
end
