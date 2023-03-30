require "rails_helper"

RSpec.describe Marketplace::CartsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path(cart.location), params: {cart: cart_attributes}
    end

    let(:cart) { build(:marketplace_cart, marketplace: marketplace, shopper: shopper) }
    let(:shopper) { create(:marketplace_shopper, person: person) }
    let(:person) { nil }

    let(:cart_attributes) { attributes_for(:marketplace_cart, shopper: shopper) }

    it { is_expected.to redirect_to(room.location) }
    specify { expect { perform_request }.to change { Marketplace::Cart.count }.by(1) }
  end

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(cart.location), params: {cart: {delivery_address: "123 N West St", delivery_window: "2022-01-05 15:00:00", contact_phone_number: "(415)-123-4567"}}
      response
    end

    let(:shopper) { create(:marketplace_shopper, person: person) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace, shopper: shopper) }

    context "when a `Guest`" do
      let(:person) { nil }

      it { is_expected.to redirect_to(room.location) }
      specify { expect { perform_request }.to change { cart.reload.delivery_address }.to("123 N West St") }
      specify { expect { perform_request }.to change { cart.reload.contact_phone_number }.to("(415)-123-4567") }
      specify { expect { perform_request }.to change { cart.reload.delivery_window }.to(DateTime.parse("2022-01-05 15:00:00")) }
    end

    context "when a `Neighbor`" do
      let(:person) { create(:person) }

      before { sign_in(space, person) }

      it { is_expected.to redirect_to(room.location) }
      specify { expect { perform_request }.to change { cart.reload.delivery_address }.to("123 N West St") }
      specify { expect { perform_request }.to change { cart.reload.contact_phone_number }.to("(415)-123-4567") }
    end
  end
end
