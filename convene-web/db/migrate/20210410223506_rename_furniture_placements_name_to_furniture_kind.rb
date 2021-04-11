class RenameFurniturePlacementsNameToFurnitureKind < ActiveRecord::Migration[6.1]
  def change
    rename_column :furniture_placements, :name, :furniture_kind
  end
end
