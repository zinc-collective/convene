# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invitation do
  it { is_expected.to belong_to(:space).inverse_of(:invitations) }
  it { is_expected.to belong_to(:invitor).class_name("Person").inverse_of(:invitations) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }

  describe "#email=" do
    it "is forced to lower case" do
      invitation = described_class.new
      invitation.email = "User@example.Com"
      expect(invitation.email).to eql("user@example.com")
    end

    it "is stripped of whitespace" do
      invitation = create(:invitation, email: " orca@yachtkillerz.org ")
      expect(invitation.email).to eql("orca@yachtkillerz.org")
    end
  end

  describe "#invitor_display_name" do
    it "is the invitors display name" do
      invitor = build(:person)
      invitation = build(:invitation, invitor: invitor)
      expect(invitation.invitor_display_name).to eq(invitor.display_name)
    end

    it "is empty when the invitor is not set" do
      invitation = build(:invitation, invitor: nil)
      expect(invitation.invitor_display_name).to be_blank
    end
  end

  describe "#status" do
    it "defines status as an enum" do
      expect(subject).to define_enum_for(:status).with_values(described_class.statuses)
        .backed_by_column_of_type(:enum)
    end

    context "when the invitation has expired" do
      let(:expired_invitation) { create(:invitation) }

      before do
        expired_invitation.update!(
          created_at: described_class::EXPIRATION_PERIOD.ago - 1.day
        )
      end

      it "doesn't allow setting status to :accepted" do
        expect(expired_invitation.update(status: :accepted)).to be(false)
        expect(expired_invitation.errors).to be_added(:base, :invitation_expired)
      end
    end
  end

  describe "#save" do
    let(:invitee) { create(:person) }

    context "with an ignored invitation" do
      let!(:ignored_invitation) { create(:invitation, :ignored, email: invitee.email) }
      let(:ignored_space) { ignored_invitation.space }

      it "does not let you create invitations for a person who has ignored the space" do
        invitation = build(:invitation, email: invitee.email, space: ignored_space)
        expect(invitation.save).to be(false)
        expect(invitation.errors).to be_added(:email, :invitee_ignored_space)
      end

      it "allows an invitation to be un-ignored" do
        expect(ignored_invitation.update(status: :pending)).to be(true)
        expect(ignored_invitation.errors).not_to be_added(:email, :invitee_ignored_space)
      end
    end
  end
end
