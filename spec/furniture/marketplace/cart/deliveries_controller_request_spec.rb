require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveriesController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(delivery.location), as: :turbo_stream, params: {delivery: {delivery_address: "123 N West St", delivery_window: "2022-01-05 15:00:00", contact_email: "contact@example.com", contact_phone_number: "(415)-123-4567"}}
      response
    end

    let(:shopper) { create(:marketplace_shopper, person: person) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace, shopper: shopper) }
    let(:delivery) { cart.delivery }

    context "when a `Guest`" do
      let(:person) { nil }

      it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "marketplace/cart/deliveries/delivery") }
      specify { expect { perform_request }.to change { delivery.reload.delivery_address }.from(nil).to("123 N West St") }
      specify { expect { perform_request }.to change { delivery.reload.contact_phone_number }.from(nil).to("(415)-123-4567") }
      specify { expect { perform_request }.to change { delivery.reload.delivery_window }.from(nil).to(DateTime.parse("2022-01-05 15:00:00")) }
    end

    context "when a `Neighbor`" do
      let(:person) { create(:person) }

      before { sign_in(space, person) }

      it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "marketplace/cart/deliveries/delivery") }
      specify { expect { perform_request }.to change { delivery.reload.delivery_address }.from(nil).to("123 N West St") }
      specify { expect { perform_request }.to change { delivery.reload.contact_phone_number }.from(nil).to("(415)-123-4567") }

      context "when the delivery is invalid" do
        # @todo this doesn't actually assert the content matches....
        it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "marketplace/cart/deliveries/form") }
      end
    end
  end
end
