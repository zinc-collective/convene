class AddJournalKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :journal_keywords, id: :uuid do |t|
      t.references :journal, type: :uuid, foreign_key: {to_table: :furnitures}
      t.string :canonical_keyword
      t.string :aliases, array: true
      t.timestamps
    end
  end
end
