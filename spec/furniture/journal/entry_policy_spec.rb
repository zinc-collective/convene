require 'rails_helper'

RSpec.describe Journal::EntryPolicy, type: :policy do
  subject { described_class }

  let(:entry) { create(:journal_entry) }
  let(:membership) { create(:membership, space: entry.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.not_to permit(Guest.new, entry) }
    it { is_expected.not_to permit(nil, entry) }
    it { is_expected.not_to permit(non_member, entry) }
    it { is_expected.to permit(member, entry) }
  end

  permissions :index? do
    it { is_expected.to permit(member, entry) }

    it { is_expected.to permit(Guest.new, entry) }
    it { is_expected.to permit(nil, entry) }
    it { is_expected.to permit(non_member, entry) }
  end

  permissions :show? do
    context 'when the entry is published' do
      let(:entry) { create(:journal_entry, published_at: 1.minute.ago) }
      it { is_expected.to permit(member, entry) }

      it { is_expected.to permit(Guest.new, entry) }
      it { is_expected.to permit(nil, entry) }
      it { is_expected.to permit(non_member, entry) }
    end

    context 'when the entry is unpublished' do
      it { is_expected.to permit(member, entry) }

      it { is_expected.not_to permit(Guest.new, entry) }
      it { is_expected.not_to permit(nil, entry) }
      it { is_expected.not_to permit(non_member, entry) }
    end
  end

  describe Journal::EntryPolicy::Scope do
    let(:space) { published_entry.space }
    let!(:published_entry) { create(:journal_entry, published_at: 1.year.ago) }

    let!(:unpublished_entry) { create(:journal_entry, journal: published_entry.journal) }

    subject(:results) { described_class.new(user, Journal::Entry.all).resolve }

    context 'When a Guest' do
      let(:user) { Guest.new }
      it { is_expected.not_to include(unpublished_entry) }
      it { is_expected.to include(published_entry) }
    end

    context 'when a member of the space' do
      let(:user) {  create(:membership, space: space).member }
      it { is_expected.to include(unpublished_entry) }
      it { is_expected.to include(published_entry) }
    end
  end
end
