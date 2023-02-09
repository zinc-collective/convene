require "rails_helper"

RSpec.describe Marketplace::StripeAccountsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:member) { create(:membership, space: space).member }
  let!(:stripe) { create(:stripe_utility, space: space, configuration: {"api_token" => "asdf"}) }
  let(:stripe_account_link) { double(Stripe::AccountLink, url: "http://example.com/") }
  let(:stripe_account) { double(Stripe::Account, id: "ac_1234", details_submitted?: false) }
  let(:stripe_webhook_endpoint) { double(Stripe::WebhookEndpoint, id: "whe_1234", secret: "oooooooooooo") }

  before do
    allow(Stripe::Account).to receive(:create).and_return(stripe_account)
    allow(Stripe::AccountLink).to receive(:create).and_return(stripe_account_link)
    allow(Stripe::WebhookEndpoint).to receive(:create)
      .with({
        enabled_events: ["checkout.session.completed"],
        url: polymorphic_url(marketplace.location(child: :stripe_events))
      }, {api_key: marketplace.stripe_api_key})
      .and_return(stripe_webhook_endpoint)
  end

  describe "#create" do
    subject(:call) do
      sign_in(space, member)
      post polymorphic_path(marketplace.location(child: :stripe_account))
      response
    end

    specify { expect { call }.to change { marketplace.reload.stripe_webhook_endpoint }.to(stripe_webhook_endpoint.id) }
    specify { expect { call }.to change { marketplace.reload.stripe_webhook_endpoint_secret }.to(stripe_webhook_endpoint.secret) }
    it { is_expected.to redirect_to(stripe_account_link.url) }
    # Not sure how to test this: status: :see_other, allow_other_hosts: true
  end
end
