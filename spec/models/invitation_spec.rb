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
end
