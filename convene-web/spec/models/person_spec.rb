# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to have_many(:invitations).inverse_of(:invitor) }

  describe '#member_of?' do
    let(:membership) { create(:space_membership) }
    let(:space) { membership.space }
    let(:member) { membership.member }
    let(:non_member) { create :person }

    it 'returns true for a space the person belongs to' do
      expect(member.member_of?(space)).to eq(true)
    end

    it 'returns false for a space the person does not belong to' do
      expect(non_member.member_of?(space)).to eq(false)
    end
  end
end
