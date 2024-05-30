class AddPositionIndexToFurnitures < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :furnitures, [:room_id, :position], unique: true, algorithm: :concurrently
  end
end
