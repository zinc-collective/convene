# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to have_many(:invitations).inverse_of(:invitor).with_foreign_key(:invitor_id) }
  it { is_expected.to have_many(:authentication_methods).inverse_of(:person).dependent(:destroy_async) }
  it { is_expected.to have_many(:space_memberships).inverse_of(:member).dependent(:destroy_async) }

  describe '#display_name' do
    it 'is blank when `name` and `email` are blank' do
      expect(described_class.new(name: '', email: nil).display_name).to be_blank
    end
    it 'is the `name` when `name` is present and `email` is present' do
      expect(
        described_class.new(name: 'Naomi', email: 'naomi@example.com').display_name
      ).to eq('Naomi')
    end
    it 'is the `email` when `name` is blank and `email` is present' do
      expect(
        described_class.new(name: '', email: 'naomi@example.com').display_name
      ).to eq('naomi@example.com')
    end
    it 'is the `name` when `name` is present and `email` is blank' do
      expect(
        described_class.new(name: 'Naomi', email: nil).display_name
      ).to eq('Naomi')
    end
  end

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
