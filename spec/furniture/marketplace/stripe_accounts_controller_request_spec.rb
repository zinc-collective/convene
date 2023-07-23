require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
RSpec.describe Marketplace::StripeAccountsController, type: :request do
  let(:stripe_account_link) { double(Stripe::AccountLink, url: "http://example.com/") }
  let(:stripe_account) { double(Stripe::Account, id: "ac_1234", details_submitted?: false) }
  let(:stripe_webhook_endpoint) { double(Stripe::WebhookEndpoint, id: "whe_1234", secret: "oooooooooooo") }

  before do
    create(:stripe_utility, space: space, configuration: {"api_token" => "asdf"})
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

    it "redirects to stripe account link" do
      expect(call).to redirect_to(stripe_account_link.url)
      expect(call.status).to eq(303)
      # Not sure how to test allow_other_hosts: true
    end

    context "when Stripe returns an error" do
      before do
        allow(Stripe::AccountLink).to receive(:create).and_raise(Stripe::InvalidRequestError.new("terribleness", :param))
      end

      it "redirects with error message" do
        expect(call).to redirect_to(polymorphic_path(marketplace.location(:edit)))
      end
    end
  end

  describe "#new" do
    subject(:call) do
      sign_in(space, member)
      get polymorphic_path(marketplace.location(:new, child: :stripe_account))
      response
    end

    it { is_expected.to redirect_to(marketplace.location(child: :stripe_account)) }
  end

  describe "#show" do
    subject(:call) do
      sign_in(space, member)
      get polymorphic_path(marketplace.location(child: :stripe_account))
      response
    end

    it { is_expected.to render_template(:show) }
  end
end
# rubocop:enable RSpec/VerifiedDoubles
