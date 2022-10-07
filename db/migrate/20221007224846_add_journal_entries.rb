class AddJournalEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :journal_entries do |t|
      t.references :room, type: :uuid, foreign_key: true
      t.string :headline
      t.text :body
      t.string :slug
      t.datetime :published_at
      t.timestamps
    end
  end
end
