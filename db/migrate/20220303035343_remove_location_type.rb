class RemoveLocationType < ActiveRecord::Migration[7.0]
  def change
    remove_index :items, name: :index_items_on_location, column: [:location_type, :location_id]
    remove_column :items, :location_type
    add_index :items, :location_id
  end
end
