class DropBreakoutTablesFromFurniturePlacements < ActiveRecord::Migration[7.0]
  def change
    execute("DELETE FROM furniture_placements WHERE furniture_kind='breakout_tables_by_jitsi'")
  end
end
