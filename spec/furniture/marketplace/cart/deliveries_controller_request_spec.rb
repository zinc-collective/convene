require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveriesController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(delivery.location), as: :turbo_stream, params: {delivery: delivery_attributes}
      response.tap { delivery.reload }
    end

    let(:delivery_attributes) { attributes_for(:marketplace_cart_delivery) }
    let(:shopper) { create(:marketplace_shopper, person: person) }
    let(:cart) { create(:marketplace_cart, marketplace: marketplace, shopper: shopper) }
    let(:delivery) { cart.delivery }

    context "when a `Guest`" do
      let(:person) { nil }

      it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "delivery") }

      specify do
        expect { perform_request }
          .to change(delivery, :contact_email).to(delivery_attributes[:contact_email])
          .and change(delivery, :contact_phone_number).to(delivery_attributes[:contact_phone_number])
          .and change(delivery, :delivery_window).to(DateTime.parse(delivery_attributes[:delivery_window]))
          .and change(delivery, :delivery_address).to(delivery_attributes[:delivery_address])
      end
    end

    context "when a `Neighbor`" do
      let(:person) { create(:person) }

      before { sign_in(space, person) }

      it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "delivery") }

      specify do
        expect { perform_request }
          .to change(delivery, :contact_email).to(delivery_attributes[:contact_email])
          .and change(delivery, :contact_phone_number).to(delivery_attributes[:contact_phone_number])
          .and change(delivery, :delivery_window).to(DateTime.parse(delivery_attributes[:delivery_window]))
          .and change(delivery, :delivery_address).to(delivery_attributes[:delivery_address])
      end

      context "when the delivery is invalid" do
        let(:delivery_attributes) { attributes_for(:marketplace_cart_delivery).merge(contact_phone_number: "") }

        it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "form") }
      end
    end
  end
end
