class CreatesMediaTable < ActiveRecord::Migration[7.1]
  def change
    create_table :media, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.datetime "created_at", null: false
    end
  end
end
