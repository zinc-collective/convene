require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :model do
  subject(:checkout) { described_class.new(cart: create(:marketplace_cart)) }

  describe "#complete" do
    before { checkout.complete(stripe_session_id: "asdf") }

    specify { expect(checkout.cart.stripe_session_id).to eql("asdf") }
    specify { expect(checkout.cart).to be_paid }
  end
end
