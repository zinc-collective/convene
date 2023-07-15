class JournalAddKeywordsToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :journal_entries, :keywords, :string, array: true
  end
end
