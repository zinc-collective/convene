require 'rails_helper'

RSpec.describe Marketplace::StripeEventsController, type: :request do
  let(:marketplace) { create(:marketplace, stripe_account: "sa_1234") }
  let(:space) { marketplace.space }
  let(:member) { create(:membership, space: space).member }
  let(:order) { create(:marketplace_order, :with_products)}


  # @todo ok we should probably generate this or something? I dunno...
  let(:stripe_event) { {} }

  describe "#create" do
    subject(:call) do
      sign_in(space, member)
      post polymorphic_path(marketplace.location(child: :stripe_events), params: stripe_event)
      response
    end

    specify { call && expect(Stripe::Transfer).to(have_received(:create).with({ amount: order.price_total.cents, currency: "usd", destination: marketplace.stripe_account, transfer_group: order.id }, { api_key: marketplace.api_key })) }
  end
end
