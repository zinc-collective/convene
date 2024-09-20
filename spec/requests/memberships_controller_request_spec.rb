# frozen_string_literal: true

require "rails_helper"

RSpec.describe MembershipsController do
  describe "#destroy" do
    subject(:perform_request) { delete polymorphic_path([membership.space, membership]) }

    let(:space) { create(:space, :with_members) }
    let(:membership) { create(:membership, space: space) }

    before do
      sign_in_as_member(space)
    end

    it "revokes the membership" do
      perform_request

      expect(flash[:notice]).to eq(I18n.t("memberships.destroy.success"))

      expect(membership.reload).to be_revoked
    end

    context "when not logged in as a member of the space" do
      let(:membership) { create(:membership) }

      it "does not delete the membership" do
        perform_request

        expect(response).to be_not_found
        expect(membership.reload).to be_present
        expect(membership.reload).not_to be_revoked
      end
    end
  end
end
