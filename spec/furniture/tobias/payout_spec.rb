require "rails_helper"

RSpec.describe Tobias::Payout do
  describe "#issue" do
    it "issues a Payment to each Beneficiary for their share of the #payout_amount" do
      payout = create(:tobias_payout, payout_amount_cents: 150_00)

      beneficiaries = create_list(10, :tobias_beneficiary, trust: payout.trust)

      payout.issue

      beneficiaries.each do |beneficiary|
        expect(beneficiary.payments).to exist(amount_cents: 15)
      end
    end
  end
end
