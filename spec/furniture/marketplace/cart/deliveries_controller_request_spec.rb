require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveriesController, type: :request do
  let(:marketplace) { create(:marketplace, :with_delivery_areas) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:shopper) { create(:marketplace_shopper, person: person) }
  let(:person) { nil }
  let(:cart) { create(:marketplace_cart, marketplace: marketplace, shopper: shopper) }
  let(:delivery) { cart.delivery }

  describe "#edit" do
    subject(:perform_request) do
      get polymorphic_path(delivery.location(:edit), as: :turbo_stream)
      response
    end

    it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "form") }
  end

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(delivery.location), as: :turbo_stream, params: {delivery: delivery_attributes}
      response.tap { delivery.reload }
    end

    let(:delivery_attributes) { attributes_for(:marketplace_cart_delivery, marketplace: marketplace) }

    context "when a `Guest`" do
      let(:person) { nil }

      it "replaces the cart footer" do
        perform_request
        expect(response.parsed_body).to include(
          "<turbo-stream action=\"replace\" target=\"cart-footer-#{cart.id}\""
        )
      end

      specify do
        expect { perform_request }
          .to change(delivery, :contact_email).to(delivery_attributes[:contact_email])
          .and change(delivery, :contact_phone_number).to(delivery_attributes[:contact_phone_number])
          .and change(delivery, :delivery_notes).to(delivery_attributes[:delivery_notes])
          .and change(delivery, :delivery_address).to(delivery_attributes[:delivery_address])
          .and change(delivery, :delivery_area_id).to(delivery_attributes[:delivery_area].id)
      end
    end

    context "when a `Neighbor`" do
      let(:person) { create(:marketplace_person) }

      before { sign_in(space, person) }

      it "replaces the cart footer" do
        perform_request
        expect(response.parsed_body).to include(
          "<turbo-stream action=\"replace\" target=\"cart-footer-#{cart.id}\""
        )
      end

      specify do
        expect { perform_request }
          .to change(delivery, :contact_email).to(delivery_attributes[:contact_email])
          .and change(delivery, :contact_phone_number).to(delivery_attributes[:contact_phone_number])
          .and change(delivery, :delivery_notes).to(delivery_attributes[:delivery_notes])
          .and change(delivery, :delivery_address).to(delivery_attributes[:delivery_address])
          .and change(delivery, :delivery_area_id).to(delivery_attributes[:delivery_area].id)
      end

      context "when the delivery is invalid" do
        let(:delivery_attributes) { attributes_for(:marketplace_cart_delivery, marketplace: marketplace).merge(contact_phone_number: "") }

        it { is_expected.to have_rendered_turbo_stream(:replace, delivery, partial: "form") }
      end
    end
  end
end
