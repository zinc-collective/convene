require "rails_helper"

RSpec.describe Marketplace::OrdersController, type: :request do
  let(:space) { create(:space, :with_members, member_count: 1) }
  let(:member) { space.members.first }
  let(:marketplace) { create(:marketplace, space: space) }
  let(:order) { create(:marketplace_order, marketplace: marketplace, delivery_address: "123 N West St") }

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
      specify { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
      # it { is_expected.to be_not_found}
    end
  end
end
