class AddJournalTerms < ActiveRecord::Migration[7.0]
  create_table :journal_terms, id: :uuid do |t|
    t.references :journal, type: :uuid, foreign_key: {to_table: :furnitures}
    t.string :canonical_term
    t.text :aliases
    t.timestamps
  end
end
