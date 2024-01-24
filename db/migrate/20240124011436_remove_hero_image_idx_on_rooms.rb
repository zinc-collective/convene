class RemoveHeroImageIdxOnRooms < ActiveRecord::Migration[7.1]
  def change
    # Removes unneeded index that strong migrations forces us to add when
    # initially adding the reference/foreign key
    remove_index :rooms, :hero_image_id
  end
end
