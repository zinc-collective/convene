require "rails_helper"

RSpec.describe SpaceInvitationMailer do
  describe "#space_invitation_email" do
    it "is from the support email" do
      stub_const("ENV", {"EMAIL_DEFAULT_FROM" => "Convene Support <convene-support@example.com>"})
      invitation = create(:invitation, invitor: create(:person, name: "Zee"), space: create(:space, name: "Hackertown"))
      mail = described_class.space_invitation_email(invitation)

      expect(mail.from).to eq(["convene-support@example.com"])
      expect(mail.header[:from].value).to include("Zee (via Hackertown)")
    end
  end
end
