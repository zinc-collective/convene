require "rails_helper"

RSpec.describe Marketplace::CartsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:person) { create(:person) }

  let(:shopper) { create(:marketplace_shopper, person: person) }

  describe "#update" do
    it "changes the delivery address" do
      cart = create(:marketplace_cart, marketplace: marketplace, shopper: shopper)
      sign_in(space, person)

      put polymorphic_path(cart.location), params: {cart: {delivery_address: "123 N West St"}}

      expect(response).to redirect_to(room.location)
    end
  end
end
