require 'rails_helper'

RSpec.describe Journal::EntriesController, type: :request do
  let(:journal) { create(:journal) }
  let(:space) { journal.space }
  let(:room) { journal.room }
  let(:member) { create(:person, spaces: [space]) }
  describe 'POST /entries' do
    it 'Creates an Entry in the Journal' do
      sign_in(space, member)

      attributes = attributes_for(:journal_entry)

      expect do
        post polymorphic_path([space, room, journal, :entries]), params: { entry: attributes }
      end.to change(journal.entries, :count).by(1)

      created_entry = journal.entries.first
      expect(created_entry.headline).to eql(attributes[:headline])
      expect(created_entry.body).to eql(attributes[:body])
    end
  end

  describe 'PUT /journals/:journal_id/entries/:entry_id' do
    it 'allows members to update Journal Entries' do
      sign_in(space, member)
      entry = create(:journal_entry, journal: journal)
      published_at = 1.day.ago.beginning_of_day
      expect do
        put polymorphic_path(entry.location), params: { entry: { published_at: published_at } }
      end.to change { entry.reload.published_at }.from(nil).to(published_at.to_time)
    end
  end
end
