class RemoveSpotlightsAndItems < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute("DELETE FROM furniture_placements WHERE furniture_kind='spotlight'")
      end
    end

    drop_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "location_id"
      t.jsonb "data"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.uuid "space_id"
      t.index ["location_id"], name: "index_items_on_location_id"
      t.index ["space_id"], name: "index_items_on_space_id"
    end
  end
end
