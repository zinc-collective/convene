class RenamingFurnitureSlotToPosition < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      rename_column :furnitures, :slot, :position
      change_column_default :furnitures, :position, from: nil, to: 0
      change_column_null :furnitures, :position, false
    end
  end
end
