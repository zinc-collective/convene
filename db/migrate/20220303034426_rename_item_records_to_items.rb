class RenameItemRecordsToItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :item_records, :items
    rename_index :items, :index_item_records_on_location, :index_items_on_location
  end
end
