class AddEntranceToSpaces < ActiveRecord::Migration[6.1]
  def change
    add_column :spaces, :entrance_id, :uuid, default: nil, null: true
    add_foreign_key :spaces, :rooms, column: :entrance_id
  end
end
