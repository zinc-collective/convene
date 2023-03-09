require "rails_helper"

RSpec.describe Marketplace::CartsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(cart.location), params: {cart: {delivery_address: "123 N West St", contact_phone_number: "(415)-123-4567"}}
      response
    end

    let(:shopper) { create(:marketplace_shopper, person: person) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace, shopper: shopper) }

    context "when a `Guest`" do
      let(:person) { nil }

      it { is_expected.to redirect_to(room.location) }
      specify { expect { perform_request }.to change { cart.reload.delivery_address }.from(nil).to("123 N West St") }
      specify { expect { perform_request }.to change { cart.reload.contact_phone_number }.from(nil).to("(415)-123-4567") }
    end

    context "when a `Neighbor`" do
      let(:person) { create(:person) }

      before { sign_in(space, person) }

      it { is_expected.to redirect_to(room.location) }
      specify { expect { perform_request }.to change { cart.reload.delivery_address }.from(nil).to("123 N West St") }
      specify { expect { perform_request }.to change { cart.reload.contact_phone_number }.from(nil).to("(415)-123-4567") }
    end
  end
end
