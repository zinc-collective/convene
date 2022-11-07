class AddJournalEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :journal_entries, id: :uuid do |t|
      t.references :journal, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.string :headline
      t.text :body
      t.string :slug
      t.datetime :published_at
      t.timestamps
    end
  end
end
