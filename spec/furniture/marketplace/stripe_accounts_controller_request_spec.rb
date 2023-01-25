require "rails_helper"

RSpec.describe Marketplace::StripeAccountsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }
  let!(:stripe) { create(:utility_hookup, :stripe, space: space, stripe_api_key: "asdf") }
  let(:account_link) { double(Stripe::AccountLink, url: "http://example.com/") }

  before do
    allow(Stripe::AccountLink).to receive(:create).and_return(account_link)
  end

  describe "#create" do
    subject(:call) do
      sign_in(space, member)
      post polymorphic_path(marketplace.location(child: :stripe_account))
      response
    end

    it { is_expected.to redirect_to(account_link.url) }
    # , status: :see_other, allow_other_hosts: true
  end
end
