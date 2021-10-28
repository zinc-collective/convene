class InitialFurnitureArchitecture < ActiveRecord::Migration[6.0]
  def change
    create_table :furniture_placements, id: :uuid do |t|
      t.integer :slot
      t.string :name
      t.jsonb :settings
      t.timestamps

      t.belongs_to :room, type: :uuid
    end
  end
end
