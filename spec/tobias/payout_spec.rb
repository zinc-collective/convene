require "rails_helper"
require_relative "factories/payout_factory"
require_relative "factories/beneficiary_factory"

RSpec.describe Tobias::Payout do
  describe "#issue" do
    it "issues a Payment to each Beneficiary for their share of the #payout_amount" do
      payout = create(:tobias_payout, payout_amount_cents: 150_00)

      beneficiaries = create_list(:tobias_beneficiary, 10, trust: payout.trust)

      payout.issue

      beneficiaries.each do |beneficiary|
        expect(beneficiary.payments).to exist(amount_cents: 15_00)
      end
    end
  end
end
