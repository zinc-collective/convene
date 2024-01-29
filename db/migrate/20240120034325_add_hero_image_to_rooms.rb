class AddHeroImageToRooms < ActiveRecord::Migration[7.1]
  def change
    safety_assured {
      add_column :rooms, :hero_image_id, :uuid, null: true, default: nil
      add_foreign_key :rooms, :media, column: "hero_image_id"
    }
  end
end
