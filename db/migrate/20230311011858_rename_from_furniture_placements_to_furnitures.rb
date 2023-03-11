class RenameFromFurniturePlacementsToFurnitures < ActiveRecord::Migration[7.0]
  def change
    rename_table :furniture_placements, :furnitures
  end
end
