class CreateItemRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :item_record, id: :uuid do |t|
      t.belongs_to :location, polymorphic: true, type: :uuid
      t.jsonb :data
      t.timestamps
    end
  end
end
