# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it { is_expected.to belong_to(:space).inverse_of(:invitations) }
  it { is_expected.to belong_to(:invitor).class_name('Person').inverse_of(:invitations) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it "defines status as an enum" do
    is_expected.to define_enum_for(:status).with_values(Invitation.statuses)
      .backed_by_column_of_type(:enum)
  end

  describe '#invitor_display_name' do
    it 'is the invitors display name' do
      invitor = build(:person)
      invitation = build(:invitation, invitor: invitor)
      expect(invitation.invitor_display_name).to eq(invitor.display_name)
    end

    it 'is empty when the invitor is not set' do
      invitation = build(:invitation, invitor: nil)
      expect(invitation.invitor_display_name).to be_blank
    end
  end

  describe "#save" do
    let(:invitee) { create(:person) }
    let!(:ignored_invitation) { create(:invitation, :ignored, email: invitee.email) }
    let(:ignored_space) { ignored_invitation.space }

    it "won't let you create invitations for a person who has ignored the space" do
      invitation = build(:invitation, email: invitee.email, space: ignored_space)
      expect(invitation.save).to eq(false)
      expect(invitation.errors).to be_added(:email, :invitee_ignored_space)
    end

    it "allows an invitation to be un-ignored" do
      expect(ignored_invitation.update(status: :sent)).to eq(true)
      expect(ignored_invitation.errors).not_to be_added(:email, :invitee_ignored_space)
    end
  end
end
