require "rails_helper"

RSpec.describe Marketplace::OrdersController, type: :request do
  let(:space) { create(:space, :with_members, member_count: 1) }
  let(:member) { space.members.first }
  let(:marketplace) { create(:marketplace, space: space) }
  let(:order) { create(:marketplace_order, marketplace: marketplace, delivery_address: "123 N West St") }

  describe "#index" do
    it "only includes paid orders by default" do
      sign_in(space, member)
      create(:marketplace_order, marketplace: marketplace, delivery_address: "123 W Unpaid St", status: :pre_checkout)
      create(:marketplace_order, marketplace: marketplace, delivery_address: "123 N Paid St")
      get polymorphic_path(marketplace.location(child: :orders))

      expect(response.body).to include("123 N Paid St")
      expect(response.body).not_to include("123 W Unpaid St")
    end

    it "shows the Order's Events" do
      sign_in(space, member)
      order = create(:marketplace_order, marketplace: marketplace, delivery_address: "123 N Paid St")
      order.events.create(description: "Order Placed")
      order.events.create(description: "Order Delivered")

      get polymorphic_path(marketplace.location(child: :orders))

      expect(response.body).to include("Order Placed")
      expect(response.body).to include("Order Delivered")
    end
  end

  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path(order.location)
      response
    end

    context "when the current person can see the order" do
      before { sign_in(space, member) }

      it { is_expected.to be_ok }

      specify {
        perform_request
        expect(response.body).to include("123 N West St")
      }
    end

    context "when the order is not viewable by the current person" do
      it { is_expected.to be_not_found }
    end
  end
end
