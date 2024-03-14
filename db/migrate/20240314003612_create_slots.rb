class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots, id: :uuid do |t|
      t.references :section, foreign_key: {to_table: :rooms}, type: :uuid
      t.references :slottable, polymorphic: true, type: :uuid
      t.integer :slot_order, null: true
      t.timestamps
    end
  end
end
