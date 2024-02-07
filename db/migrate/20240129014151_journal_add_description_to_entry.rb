class JournalAddDescriptionToEntry < ActiveRecord::Migration[7.1]
  def change
    add_column :journal_entries, :summary, :text
  end
end
