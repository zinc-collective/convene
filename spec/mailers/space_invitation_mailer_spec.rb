require "rails_helper"

RSpec.describe SpaceInvitationMailer do
  describe "#space_invitation_email" do
    it "is from the support email" do
      stub_const("ENV", {"EMAIL_DEFAULT_FROM" => "Convene Support <convene-support@example.com>"})
      invitation = create(:invitation, invitor: create(:person, name: "Zee"), space: create(:space, name: "Hackertown"))
      mail = described_class.space_invitation_email(invitation)

      # @todo I couldn't figure out how to actually test that it had all the information in the from
      # and I am giving up so I can get chocolate
      expect(mail.from).to eq(["convene-support@example.com"])
    end
  end
end
