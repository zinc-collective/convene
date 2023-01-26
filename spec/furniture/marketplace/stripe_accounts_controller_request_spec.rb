require "rails_helper"

RSpec.describe Marketplace::StripeAccountsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }
  let!(:stripe) { create(:utility_hookup, :stripe, space: space, configuration: { "api_token" => "asdf" }) }
  let(:stripe_account_link) { double(Stripe::AccountLink, url: "http://example.com/") }
  let(:stripe_account) { double(Stripe::Account, id: "ac_1234", details_submitted?: false)}

  before do
    allow(Stripe::Account).to receive(:create).and_return(stripe_account)
    allow(Stripe::AccountLink).to receive(:create).and_return(stripe_account_link)
  end

  describe "#create" do
    subject(:call) do
      sign_in(space, member)
      post polymorphic_path(marketplace.location(child: :stripe_account))
      response
    end

    it { is_expected.to redirect_to(stripe_account_link.url) }
    # Not sure how to test this: status: :see_other, allow_other_hosts: true
  end
end
